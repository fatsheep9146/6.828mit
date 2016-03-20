#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <assert.h>
#include <sys/types.h>
#include <sys/stat.h>

// Simplifed xv6 shell.

#define MAXARGS 10

// All commands have at least a type. Have looked at the type, the code
// typically casts the *cmd to some specific cmd type.
// 所有command的基类
struct cmd {
  int type;          //  ' ' (exec), | (pipe), '<' or '>' for redirection
};

struct execcmd {
  int type;              // ' '
  char *argv[MAXARGS];   // arguments to the command to be exec-ed
};

struct redircmd {
  int type;          // < or > 
  struct cmd *cmd;   // the command to be run (e.g., an execcmd)
  char *file;        // the input/output file
  int mode;          // the mode to open the file with
  int fd;            // the file descriptor number to use for the file
};

struct pipecmd {
  int type;          // |
  struct cmd *left;  // left side of pipe
  struct cmd *right; // right side of pipe
};

int fork1(void);  // Fork but exits on failure.
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
  int p[2], r;
  struct execcmd *ecmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;
  char *path=(char *)malloc(150*sizeof(char));     //the string to store the real path of the command
  char *root="/bin/";

  if(cmd == 0)
    exit(0);
  
  switch(cmd->type){
  default:
    fprintf(stderr, "unknown runcmd\n");
    exit(-1);

  case ' ':
    ecmd = (struct execcmd*)cmd;
    if(ecmd->argv[0] == 0)
      exit(0);
    if(access(ecmd->argv[0], F_OK) == 0) {   //If the command is found in current lib, then execute the command directly
        execv(ecmd->argv[0], ecmd->argv);
    }
    else {                                   //If the command is not found in current lib, then it must locates at /bin/
        strcpy(path, root);                  
        strcat(path, ecmd->argv[0]);         //make the absolute path of this command. for example, you type in "ls", then its absolute path is "/bin/ls"
        if(access(path, F_OK) == 0)          //If this command can be found, then execute
            execv(path, ecmd->argv);
        else {                               //If not, then the command is not legal
            fprintf(stderr, "%s: Command not found.\n", ecmd->argv[0]);       
        }
    }
    break;

  case '>':
  case '<':
    rcmd = (struct redircmd*)cmd;
	close(rcmd->fd); 						//close the original file 
    if(open(rcmd->file, rcmd->mode, 0777)<0){     //open with the new redirected file
		fprintf(stderr, "Try to open :%s failed\n", rcmd->file);
		exit(0);
	}    
    runcmd(rcmd->cmd);
    break;

  case '|':
    pcmd = (struct pipecmd*)cmd;
	if(pipe(p) < 0) {     //Create a pipe
		fprintf(stderr, "Pipe is not created successfully.\n");
	}
	if(fork1() == 0){	  //the process of left cmd
		close(1);		  //redirect the output of the left command.
		dup(p[1]);
		close(p[0]);	  //close other file descripter, in case that the  "read" command will be blocked, because there are some file descripters is pointing to the write file descripter of pipe. 
		close(p[1]);
		runcmd(pcmd->left);	
	}
	if(fork1() == 0){
		close(0);
		dup(p[0]);
		close(p[0]);
		close(p[1]);
		runcmd(pcmd->right);
	}
	close(p[0]);
	close(p[1]);
	wait(&r);
	wait(&r);
    break;
  }    
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
  
  if (isatty(fileno(stdin)))
    fprintf(stdout, "$ ");
  memset(buf, 0, nbuf);
  fgets(buf, nbuf, stdin);
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}

int
main(void)
{
  static char buf[100];
  int fd, r;

  // Read and run input commands. 
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        fprintf(stderr, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait(&r);
  }
  exit(0);
}

int
fork1(void)
{
  int pid;
  
  pid = fork();
  if(pid == -1)
    perror("fork");
  return pid;
}


/*
	该函数新建一个execcmd类型的变量，并且为其分配空间，但是把它强制转换为cmd类型才返回
*/
struct cmd*
execcmd(void)
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = ' ';
  return (struct cmd*)cmd;
}

struct cmd*
redircmd(struct cmd *subcmd, char *file, int type)
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = type;
  cmd->cmd = subcmd;
  cmd->file = file;
  cmd->mode = (type == '<') ?  O_RDONLY : O_WRONLY|O_CREAT|O_TRUNC;
  cmd->fd = (type == '<') ? 0 : 1;
  return (struct cmd*)cmd;
}

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = '|';
  cmd->left = left;
  cmd->right = right;
  return (struct cmd*)cmd;
}

// Parsing

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>";

/*
	先把字符串的前导空白符滤掉，然后如果第一个字符是"| < >"中的任意一种，则返回这个符号后面的第一个非空白字符的位置。
	如果第一个字符不是上述符号的任意一种，则应该是一个子字符串，则返回'a'的ASCII值，并且把字符串定位到这段子串后的第一个空字符或| < >符号钱
	q. eq中存放该段子字符串的开头和结尾
*/
int
gettoken(char **ps, char *es, char **q, char **eq)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))    //过滤掉开头的空字符
    s++;
  if(q)				//如果q输入参数有有意义的值                          
    *q = s;         //把q指向当前字符串的首字符指针
  ret = *s;         //ret中存放的是当前首字符
  switch(*s){       //判断这个首字符
  case 0:           //首字符为结束符
    break;
  case '|':         //首字符为"|"
  case '<':         //首字符为"<"
    s++;            
    break;
  case '>':
    s++;
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))    //如果首字符不是上面三种字符的任意一种，则把s向后移动，直到遇到一个空白符，或者symbols中的字符
      s++;
    break;
  }
  if(eq)            
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))  //再把新出现的前导空白符去掉
    s++;
  *ps = s;    //把字符串的头部改为现在的s的这个位置
  return ret;
}


/*
	所以这个函数就是判断ps所指向的字符指针所指向的字符串的首字符是否是tok中的一种，并且会把该字符串的前驱空白字符都删掉
*/
int
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;   //s现在是字符串的开头字符的指针
  while(s < es && strchr(whitespace, *s))    //判断s所指向的字符是否属于whitespace中的一种，如果是则s向后移动
    s++;
  *ps = s;      //现在让ps指向这个把前方的空白字符去掉的新字符串的首字符的指针的指针 
  return *s && strchr(toks, *s);     //如果此时去掉空白字符后该字符串首字符*s不为空，并且这个首字符是toks中的一种字符
}

struct cmd *parseline(char**, char*);
struct cmd *parsepipe(char**, char*);
struct cmd *parseexec(char**, char*);

// make a copy of the characters in the input buffer, starting from s through es.
// null-terminate the copy to make it a string.
char 
*mkcopy(char *s, char *es)
{
  int n = es - s;
  char *c = malloc(n+1);
  assert(c);
  strncpy(c, s, n);
  c[n] = 0;
  return c;
}


/*
	分析指令函数   *s是存放指令字符数组的指针
*/
struct cmd*
parsecmd(char *s)    
{
  char *es;
  struct cmd *cmd;    

  es = s + strlen(s);    //es指向这个字符数组的末尾元素   
  cmd = parseline(&s, es);   
  peek(&s, es, "");
  if(s != es){
    fprintf(stderr, "leftovers: %s\n", s);
    exit(-1);
  }
  return cmd;
}

/*
	分析一行，**ps是指向这一行字符的头指针的指针，es是指向这个字符串数组最后一个字符的指针。
*/
struct cmd*
parseline(char **ps, char *es)
{
  struct cmd *cmd;
  cmd = parsepipe(ps, es);
  return cmd;
}


/*
	分析pipe
*/
struct cmd*
parsepipe(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
  }
  return cmd;
}


/*
	按字面意思理解应该是分析重定向行为的函数
*/
struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){   //去掉前导空白符，并且判断该字符串的首字符是否是<>中的一种
    tok = gettoken(ps, es, 0, 0);    //如果存在 <> 符号，那么定位这个 <> 符号左面的那个指令 如 $， ps 
    if(gettoken(ps, es, &q, &eq) != 'a') {   
      fprintf(stderr, "missing file for redirection\n");
      exit(-1);
    }
    switch(tok){
    case '<':
      cmd = redircmd(cmd, mkcopy(q, eq), '<');
      break;
    case '>':
      cmd = redircmd(cmd, mkcopy(q, eq), '>');
      break;
    }
  }
  return cmd;
}



struct cmd*
parseexec(char **ps, char *es)
{
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;    //cmd是指向execcmd类型变量的指针
  struct cmd *ret;        //ret是指向基类cmd类型变量的指针
  
  ret = execcmd();      //新建一个cmd类型变量，但是实际是execcmd类型的  
  cmd = (struct execcmd*)ret;   //让一个execcmd的指针指向它

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|")){
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a') {
      fprintf(stderr, "syntax error\n");
      exit(-1);
    }
    cmd->argv[argc] = mkcopy(q, eq);
    argc++;
    if(argc >= MAXARGS) {
      fprintf(stderr, "too many args\n");
      exit(-1);
    }
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  return ret;
}
