
obj/user/ls.debug:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 93 02 00 00       	call   8002c4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003b:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  80003e:	83 3d f0 41 80 00 00 	cmpl   $0x0,0x8041f0
  800045:	74 20                	je     800067 <ls1+0x34>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800047:	89 f0                	mov    %esi,%eax
  800049:	3c 01                	cmp    $0x1,%al
  80004b:	19 c0                	sbb    %eax,%eax
  80004d:	83 e0 c9             	and    $0xffffffc9,%eax
  800050:	83 c0 64             	add    $0x64,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	ff 75 10             	pushl  0x10(%ebp)
  80005a:	68 02 23 80 00       	push   $0x802302
  80005f:	e8 99 19 00 00       	call   8019fd <printf>
  800064:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  800067:	85 db                	test   %ebx,%ebx
  800069:	74 3a                	je     8000a5 <ls1+0x72>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006b:	b8 68 23 80 00       	mov    $0x802368,%eax
	const char *sep;

	if(flag['l'])
		printf("%11d %c ", size, isdir ? 'd' : '-');
	if(prefix) {
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800070:	80 3b 00             	cmpb   $0x0,(%ebx)
  800073:	74 1e                	je     800093 <ls1+0x60>
  800075:	83 ec 0c             	sub    $0xc,%esp
  800078:	53                   	push   %ebx
  800079:	e8 cd 08 00 00       	call   80094b <strlen>
  80007e:	83 c4 10             	add    $0x10,%esp
			sep = "/";
		else
			sep = "";
  800081:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  800086:	ba 68 23 80 00       	mov    $0x802368,%edx
  80008b:	b8 00 23 80 00       	mov    $0x802300,%eax
  800090:	0f 44 c2             	cmove  %edx,%eax
		printf("%s%s", prefix, sep);
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	50                   	push   %eax
  800097:	53                   	push   %ebx
  800098:	68 0b 23 80 00       	push   $0x80230b
  80009d:	e8 5b 19 00 00       	call   8019fd <printf>
  8000a2:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  8000a5:	83 ec 08             	sub    $0x8,%esp
  8000a8:	ff 75 14             	pushl  0x14(%ebp)
  8000ab:	68 b5 27 80 00       	push   $0x8027b5
  8000b0:	e8 48 19 00 00       	call   8019fd <printf>
	if(flag['F'] && isdir)
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 f0                	mov    %esi,%eax
  8000ba:	84 c0                	test   %al,%al
  8000bc:	74 19                	je     8000d7 <ls1+0xa4>
  8000be:	83 3d 58 41 80 00 00 	cmpl   $0x0,0x804158
  8000c5:	74 10                	je     8000d7 <ls1+0xa4>
		printf("/");
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	68 00 23 80 00       	push   $0x802300
  8000cf:	e8 29 19 00 00       	call   8019fd <printf>
  8000d4:	83 c4 10             	add    $0x10,%esp
	printf("\n");
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	68 67 23 80 00       	push   $0x802367
  8000df:	e8 19 19 00 00       	call   8019fd <printf>
  8000e4:	83 c4 10             	add    $0x10,%esp
}
  8000e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ea:	5b                   	pop    %ebx
  8000eb:	5e                   	pop    %esi
  8000ec:	5d                   	pop    %ebp
  8000ed:	c3                   	ret    

008000ee <lsdir>:
		ls1(0, st.st_isdir, st.st_size, path);
}

void
lsdir(const char *path, const char *prefix)
{
  8000ee:	55                   	push   %ebp
  8000ef:	89 e5                	mov    %esp,%ebp
  8000f1:	57                   	push   %edi
  8000f2:	56                   	push   %esi
  8000f3:	53                   	push   %ebx
  8000f4:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8000fa:	8b 7d 08             	mov    0x8(%ebp),%edi
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  8000fd:	6a 00                	push   $0x0
  8000ff:	57                   	push   %edi
  800100:	e8 5a 17 00 00       	call   80185f <open>
  800105:	89 c3                	mov    %eax,%ebx
  800107:	83 c4 10             	add    $0x10,%esp
  80010a:	85 c0                	test   %eax,%eax
  80010c:	79 41                	jns    80014f <lsdir+0x61>
		panic("open %s: %e", path, fd);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	50                   	push   %eax
  800112:	57                   	push   %edi
  800113:	68 10 23 80 00       	push   $0x802310
  800118:	6a 1d                	push   $0x1d
  80011a:	68 1c 23 80 00       	push   $0x80231c
  80011f:	e8 00 02 00 00       	call   800324 <_panic>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0])
  800124:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  80012b:	74 28                	je     800155 <lsdir+0x67>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  80012d:	56                   	push   %esi
  80012e:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
  800134:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  80013b:	0f 94 c0             	sete   %al
  80013e:	0f b6 c0             	movzbl %al,%eax
  800141:	50                   	push   %eax
  800142:	ff 75 0c             	pushl  0xc(%ebp)
  800145:	e8 e9 fe ff ff       	call   800033 <ls1>
  80014a:	83 c4 10             	add    $0x10,%esp
  80014d:	eb 06                	jmp    800155 <lsdir+0x67>
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80014f:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 00 01 00 00       	push   $0x100
  80015d:	56                   	push   %esi
  80015e:	53                   	push   %ebx
  80015f:	e8 df 12 00 00       	call   801443 <readn>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	3d 00 01 00 00       	cmp    $0x100,%eax
  80016c:	74 b6                	je     800124 <lsdir+0x36>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  80016e:	85 c0                	test   %eax,%eax
  800170:	7e 12                	jle    800184 <lsdir+0x96>
		panic("short read in directory %s", path);
  800172:	57                   	push   %edi
  800173:	68 26 23 80 00       	push   $0x802326
  800178:	6a 22                	push   $0x22
  80017a:	68 1c 23 80 00       	push   $0x80231c
  80017f:	e8 a0 01 00 00       	call   800324 <_panic>
	if (n < 0)
  800184:	85 c0                	test   %eax,%eax
  800186:	79 16                	jns    80019e <lsdir+0xb0>
		panic("error reading directory %s: %e", path, n);
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	50                   	push   %eax
  80018c:	57                   	push   %edi
  80018d:	68 6c 23 80 00       	push   $0x80236c
  800192:	6a 24                	push   $0x24
  800194:	68 1c 23 80 00       	push   $0x80231c
  800199:	e8 86 01 00 00       	call   800324 <_panic>
}
  80019e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a1:	5b                   	pop    %ebx
  8001a2:	5e                   	pop    %esi
  8001a3:	5f                   	pop    %edi
  8001a4:	5d                   	pop    %ebp
  8001a5:	c3                   	ret    

008001a6 <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	53                   	push   %ebx
  8001aa:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8001b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  8001b3:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  8001b9:	50                   	push   %eax
  8001ba:	53                   	push   %ebx
  8001bb:	e8 84 14 00 00       	call   801644 <stat>
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	85 c0                	test   %eax,%eax
  8001c5:	79 16                	jns    8001dd <ls+0x37>
		panic("stat %s: %e", path, r);
  8001c7:	83 ec 0c             	sub    $0xc,%esp
  8001ca:	50                   	push   %eax
  8001cb:	53                   	push   %ebx
  8001cc:	68 41 23 80 00       	push   $0x802341
  8001d1:	6a 0f                	push   $0xf
  8001d3:	68 1c 23 80 00       	push   $0x80231c
  8001d8:	e8 47 01 00 00       	call   800324 <_panic>
	if (st.st_isdir && !flag['d'])
  8001dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001e0:	85 c0                	test   %eax,%eax
  8001e2:	74 1a                	je     8001fe <ls+0x58>
  8001e4:	83 3d d0 41 80 00 00 	cmpl   $0x0,0x8041d0
  8001eb:	75 11                	jne    8001fe <ls+0x58>
		lsdir(path, prefix);
  8001ed:	83 ec 08             	sub    $0x8,%esp
  8001f0:	ff 75 0c             	pushl  0xc(%ebp)
  8001f3:	53                   	push   %ebx
  8001f4:	e8 f5 fe ff ff       	call   8000ee <lsdir>
  8001f9:	83 c4 10             	add    $0x10,%esp
  8001fc:	eb 17                	jmp    800215 <ls+0x6f>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  8001fe:	53                   	push   %ebx
  8001ff:	ff 75 ec             	pushl  -0x14(%ebp)
  800202:	85 c0                	test   %eax,%eax
  800204:	0f 95 c0             	setne  %al
  800207:	0f b6 c0             	movzbl %al,%eax
  80020a:	50                   	push   %eax
  80020b:	6a 00                	push   $0x0
  80020d:	e8 21 fe ff ff       	call   800033 <ls1>
  800212:	83 c4 10             	add    $0x10,%esp
}
  800215:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800218:	c9                   	leave  
  800219:	c3                   	ret    

0080021a <usage>:
	printf("\n");
}

void
usage(void)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	83 ec 14             	sub    $0x14,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800220:	68 4d 23 80 00       	push   $0x80234d
  800225:	e8 d3 17 00 00       	call   8019fd <printf>
	exit();
  80022a:	e8 db 00 00 00       	call   80030a <exit>
  80022f:	83 c4 10             	add    $0x10,%esp
}
  800232:	c9                   	leave  
  800233:	c3                   	ret    

00800234 <umain>:

void
umain(int argc, char **argv)
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	56                   	push   %esi
  800238:	53                   	push   %ebx
  800239:	83 ec 14             	sub    $0x14,%esp
  80023c:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  80023f:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800242:	50                   	push   %eax
  800243:	56                   	push   %esi
  800244:	8d 45 08             	lea    0x8(%ebp),%eax
  800247:	50                   	push   %eax
  800248:	e8 31 0d 00 00       	call   800f7e <argstart>
	while ((i = argnext(&args)) >= 0)
  80024d:	83 c4 10             	add    $0x10,%esp
  800250:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  800253:	eb 1e                	jmp    800273 <umain+0x3f>
		switch (i) {
  800255:	83 f8 64             	cmp    $0x64,%eax
  800258:	74 0a                	je     800264 <umain+0x30>
  80025a:	83 f8 6c             	cmp    $0x6c,%eax
  80025d:	74 05                	je     800264 <umain+0x30>
  80025f:	83 f8 46             	cmp    $0x46,%eax
  800262:	75 0a                	jne    80026e <umain+0x3a>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800264:	83 04 85 40 40 80 00 	addl   $0x1,0x804040(,%eax,4)
  80026b:	01 
			break;
  80026c:	eb 05                	jmp    800273 <umain+0x3f>
		default:
			usage();
  80026e:	e8 a7 ff ff ff       	call   80021a <usage>
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	53                   	push   %ebx
  800277:	e8 32 0d 00 00       	call   800fae <argnext>
  80027c:	83 c4 10             	add    $0x10,%esp
  80027f:	85 c0                	test   %eax,%eax
  800281:	79 d2                	jns    800255 <umain+0x21>
  800283:	bb 01 00 00 00       	mov    $0x1,%ebx
			break;
		default:
			usage();
		}

	if (argc == 1)
  800288:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80028c:	75 2a                	jne    8002b8 <umain+0x84>
		ls("/", "");
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	68 68 23 80 00       	push   $0x802368
  800296:	68 00 23 80 00       	push   $0x802300
  80029b:	e8 06 ff ff ff       	call   8001a6 <ls>
  8002a0:	83 c4 10             	add    $0x10,%esp
  8002a3:	eb 18                	jmp    8002bd <umain+0x89>
	else {
		for (i = 1; i < argc; i++)
			ls(argv[i], argv[i]);
  8002a5:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8002a8:	83 ec 08             	sub    $0x8,%esp
  8002ab:	50                   	push   %eax
  8002ac:	50                   	push   %eax
  8002ad:	e8 f4 fe ff ff       	call   8001a6 <ls>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  8002b2:	83 c3 01             	add    $0x1,%ebx
  8002b5:	83 c4 10             	add    $0x10,%esp
  8002b8:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  8002bb:	7c e8                	jl     8002a5 <umain+0x71>
			ls(argv[i], argv[i]);
	}
}
  8002bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002c0:	5b                   	pop    %ebx
  8002c1:	5e                   	pop    %esi
  8002c2:	5d                   	pop    %ebp
  8002c3:	c3                   	ret    

008002c4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	56                   	push   %esi
  8002c8:	53                   	push   %ebx
  8002c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002cc:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  8002cf:	e8 7b 0a 00 00       	call   800d4f <sys_getenvid>
  8002d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002d9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002dc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e1:	a3 40 44 80 00       	mov    %eax,0x804440

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002e6:	85 db                	test   %ebx,%ebx
  8002e8:	7e 07                	jle    8002f1 <libmain+0x2d>
		binaryname = argv[0];
  8002ea:	8b 06                	mov    (%esi),%eax
  8002ec:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8002f1:	83 ec 08             	sub    $0x8,%esp
  8002f4:	56                   	push   %esi
  8002f5:	53                   	push   %ebx
  8002f6:	e8 39 ff ff ff       	call   800234 <umain>

	// exit gracefully
	exit();
  8002fb:	e8 0a 00 00 00       	call   80030a <exit>
  800300:	83 c4 10             	add    $0x10,%esp
}
  800303:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800306:	5b                   	pop    %ebx
  800307:	5e                   	pop    %esi
  800308:	5d                   	pop    %ebp
  800309:	c3                   	ret    

0080030a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800310:	e8 8a 0f 00 00       	call   80129f <close_all>
	sys_env_destroy(0);
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	6a 00                	push   $0x0
  80031a:	e8 ef 09 00 00       	call   800d0e <sys_env_destroy>
  80031f:	83 c4 10             	add    $0x10,%esp
}
  800322:	c9                   	leave  
  800323:	c3                   	ret    

00800324 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	56                   	push   %esi
  800328:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800329:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80032c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800332:	e8 18 0a 00 00       	call   800d4f <sys_getenvid>
  800337:	83 ec 0c             	sub    $0xc,%esp
  80033a:	ff 75 0c             	pushl  0xc(%ebp)
  80033d:	ff 75 08             	pushl  0x8(%ebp)
  800340:	56                   	push   %esi
  800341:	50                   	push   %eax
  800342:	68 98 23 80 00       	push   $0x802398
  800347:	e8 b1 00 00 00       	call   8003fd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80034c:	83 c4 18             	add    $0x18,%esp
  80034f:	53                   	push   %ebx
  800350:	ff 75 10             	pushl  0x10(%ebp)
  800353:	e8 54 00 00 00       	call   8003ac <vcprintf>
	cprintf("\n");
  800358:	c7 04 24 67 23 80 00 	movl   $0x802367,(%esp)
  80035f:	e8 99 00 00 00       	call   8003fd <cprintf>
  800364:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800367:	cc                   	int3   
  800368:	eb fd                	jmp    800367 <_panic+0x43>

0080036a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	53                   	push   %ebx
  80036e:	83 ec 04             	sub    $0x4,%esp
  800371:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800374:	8b 13                	mov    (%ebx),%edx
  800376:	8d 42 01             	lea    0x1(%edx),%eax
  800379:	89 03                	mov    %eax,(%ebx)
  80037b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80037e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800382:	3d ff 00 00 00       	cmp    $0xff,%eax
  800387:	75 1a                	jne    8003a3 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800389:	83 ec 08             	sub    $0x8,%esp
  80038c:	68 ff 00 00 00       	push   $0xff
  800391:	8d 43 08             	lea    0x8(%ebx),%eax
  800394:	50                   	push   %eax
  800395:	e8 37 09 00 00       	call   800cd1 <sys_cputs>
		b->idx = 0;
  80039a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003a0:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8003a3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003aa:	c9                   	leave  
  8003ab:	c3                   	ret    

008003ac <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003ac:	55                   	push   %ebp
  8003ad:	89 e5                	mov    %esp,%ebp
  8003af:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003b5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003bc:	00 00 00 
	b.cnt = 0;
  8003bf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003c6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003c9:	ff 75 0c             	pushl  0xc(%ebp)
  8003cc:	ff 75 08             	pushl  0x8(%ebp)
  8003cf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003d5:	50                   	push   %eax
  8003d6:	68 6a 03 80 00       	push   $0x80036a
  8003db:	e8 4f 01 00 00       	call   80052f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003e0:	83 c4 08             	add    $0x8,%esp
  8003e3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003e9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003ef:	50                   	push   %eax
  8003f0:	e8 dc 08 00 00       	call   800cd1 <sys_cputs>

	return b.cnt;
}
  8003f5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003fb:	c9                   	leave  
  8003fc:	c3                   	ret    

008003fd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003fd:	55                   	push   %ebp
  8003fe:	89 e5                	mov    %esp,%ebp
  800400:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800403:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800406:	50                   	push   %eax
  800407:	ff 75 08             	pushl  0x8(%ebp)
  80040a:	e8 9d ff ff ff       	call   8003ac <vcprintf>
	va_end(ap);

	return cnt;
}
  80040f:	c9                   	leave  
  800410:	c3                   	ret    

00800411 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800411:	55                   	push   %ebp
  800412:	89 e5                	mov    %esp,%ebp
  800414:	57                   	push   %edi
  800415:	56                   	push   %esi
  800416:	53                   	push   %ebx
  800417:	83 ec 1c             	sub    $0x1c,%esp
  80041a:	89 c7                	mov    %eax,%edi
  80041c:	89 d6                	mov    %edx,%esi
  80041e:	8b 45 08             	mov    0x8(%ebp),%eax
  800421:	8b 55 0c             	mov    0xc(%ebp),%edx
  800424:	89 d1                	mov    %edx,%ecx
  800426:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800429:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80042c:	8b 45 10             	mov    0x10(%ebp),%eax
  80042f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800432:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800435:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80043c:	39 4d e4             	cmp    %ecx,-0x1c(%ebp)
  80043f:	72 05                	jb     800446 <printnum+0x35>
  800441:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800444:	77 3e                	ja     800484 <printnum+0x73>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800446:	83 ec 0c             	sub    $0xc,%esp
  800449:	ff 75 18             	pushl  0x18(%ebp)
  80044c:	83 eb 01             	sub    $0x1,%ebx
  80044f:	53                   	push   %ebx
  800450:	50                   	push   %eax
  800451:	83 ec 08             	sub    $0x8,%esp
  800454:	ff 75 e4             	pushl  -0x1c(%ebp)
  800457:	ff 75 e0             	pushl  -0x20(%ebp)
  80045a:	ff 75 dc             	pushl  -0x24(%ebp)
  80045d:	ff 75 d8             	pushl  -0x28(%ebp)
  800460:	e8 bb 1b 00 00       	call   802020 <__udivdi3>
  800465:	83 c4 18             	add    $0x18,%esp
  800468:	52                   	push   %edx
  800469:	50                   	push   %eax
  80046a:	89 f2                	mov    %esi,%edx
  80046c:	89 f8                	mov    %edi,%eax
  80046e:	e8 9e ff ff ff       	call   800411 <printnum>
  800473:	83 c4 20             	add    $0x20,%esp
  800476:	eb 13                	jmp    80048b <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800478:	83 ec 08             	sub    $0x8,%esp
  80047b:	56                   	push   %esi
  80047c:	ff 75 18             	pushl  0x18(%ebp)
  80047f:	ff d7                	call   *%edi
  800481:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800484:	83 eb 01             	sub    $0x1,%ebx
  800487:	85 db                	test   %ebx,%ebx
  800489:	7f ed                	jg     800478 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80048b:	83 ec 08             	sub    $0x8,%esp
  80048e:	56                   	push   %esi
  80048f:	83 ec 04             	sub    $0x4,%esp
  800492:	ff 75 e4             	pushl  -0x1c(%ebp)
  800495:	ff 75 e0             	pushl  -0x20(%ebp)
  800498:	ff 75 dc             	pushl  -0x24(%ebp)
  80049b:	ff 75 d8             	pushl  -0x28(%ebp)
  80049e:	e8 ad 1c 00 00       	call   802150 <__umoddi3>
  8004a3:	83 c4 14             	add    $0x14,%esp
  8004a6:	0f be 80 bb 23 80 00 	movsbl 0x8023bb(%eax),%eax
  8004ad:	50                   	push   %eax
  8004ae:	ff d7                	call   *%edi
  8004b0:	83 c4 10             	add    $0x10,%esp
}
  8004b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004b6:	5b                   	pop    %ebx
  8004b7:	5e                   	pop    %esi
  8004b8:	5f                   	pop    %edi
  8004b9:	5d                   	pop    %ebp
  8004ba:	c3                   	ret    

008004bb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004bb:	55                   	push   %ebp
  8004bc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004be:	83 fa 01             	cmp    $0x1,%edx
  8004c1:	7e 0e                	jle    8004d1 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8004c3:	8b 10                	mov    (%eax),%edx
  8004c5:	8d 4a 08             	lea    0x8(%edx),%ecx
  8004c8:	89 08                	mov    %ecx,(%eax)
  8004ca:	8b 02                	mov    (%edx),%eax
  8004cc:	8b 52 04             	mov    0x4(%edx),%edx
  8004cf:	eb 22                	jmp    8004f3 <getuint+0x38>
	else if (lflag)
  8004d1:	85 d2                	test   %edx,%edx
  8004d3:	74 10                	je     8004e5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8004d5:	8b 10                	mov    (%eax),%edx
  8004d7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004da:	89 08                	mov    %ecx,(%eax)
  8004dc:	8b 02                	mov    (%edx),%eax
  8004de:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e3:	eb 0e                	jmp    8004f3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004e5:	8b 10                	mov    (%eax),%edx
  8004e7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004ea:	89 08                	mov    %ecx,(%eax)
  8004ec:	8b 02                	mov    (%edx),%eax
  8004ee:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f3:	5d                   	pop    %ebp
  8004f4:	c3                   	ret    

008004f5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004fb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004ff:	8b 10                	mov    (%eax),%edx
  800501:	3b 50 04             	cmp    0x4(%eax),%edx
  800504:	73 0a                	jae    800510 <sprintputch+0x1b>
		*b->buf++ = ch;
  800506:	8d 4a 01             	lea    0x1(%edx),%ecx
  800509:	89 08                	mov    %ecx,(%eax)
  80050b:	8b 45 08             	mov    0x8(%ebp),%eax
  80050e:	88 02                	mov    %al,(%edx)
}
  800510:	5d                   	pop    %ebp
  800511:	c3                   	ret    

00800512 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800512:	55                   	push   %ebp
  800513:	89 e5                	mov    %esp,%ebp
  800515:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800518:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80051b:	50                   	push   %eax
  80051c:	ff 75 10             	pushl  0x10(%ebp)
  80051f:	ff 75 0c             	pushl  0xc(%ebp)
  800522:	ff 75 08             	pushl  0x8(%ebp)
  800525:	e8 05 00 00 00       	call   80052f <vprintfmt>
	va_end(ap);
  80052a:	83 c4 10             	add    $0x10,%esp
}
  80052d:	c9                   	leave  
  80052e:	c3                   	ret    

0080052f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80052f:	55                   	push   %ebp
  800530:	89 e5                	mov    %esp,%ebp
  800532:	57                   	push   %edi
  800533:	56                   	push   %esi
  800534:	53                   	push   %ebx
  800535:	83 ec 2c             	sub    $0x2c,%esp
  800538:	8b 75 08             	mov    0x8(%ebp),%esi
  80053b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80053e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800541:	eb 12                	jmp    800555 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800543:	85 c0                	test   %eax,%eax
  800545:	0f 84 90 03 00 00    	je     8008db <vprintfmt+0x3ac>
				return;
			putch(ch, putdat);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	53                   	push   %ebx
  80054f:	50                   	push   %eax
  800550:	ff d6                	call   *%esi
  800552:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800555:	83 c7 01             	add    $0x1,%edi
  800558:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80055c:	83 f8 25             	cmp    $0x25,%eax
  80055f:	75 e2                	jne    800543 <vprintfmt+0x14>
  800561:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800565:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80056c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800573:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80057a:	ba 00 00 00 00       	mov    $0x0,%edx
  80057f:	eb 07                	jmp    800588 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800581:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800584:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800588:	8d 47 01             	lea    0x1(%edi),%eax
  80058b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80058e:	0f b6 07             	movzbl (%edi),%eax
  800591:	0f b6 c8             	movzbl %al,%ecx
  800594:	83 e8 23             	sub    $0x23,%eax
  800597:	3c 55                	cmp    $0x55,%al
  800599:	0f 87 21 03 00 00    	ja     8008c0 <vprintfmt+0x391>
  80059f:	0f b6 c0             	movzbl %al,%eax
  8005a2:	ff 24 85 00 25 80 00 	jmp    *0x802500(,%eax,4)
  8005a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005ac:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8005b0:	eb d6                	jmp    800588 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8005bd:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005c0:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8005c4:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8005c7:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8005ca:	83 fa 09             	cmp    $0x9,%edx
  8005cd:	77 39                	ja     800608 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005cf:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005d2:	eb e9                	jmp    8005bd <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	8d 48 04             	lea    0x4(%eax),%ecx
  8005da:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005e5:	eb 27                	jmp    80060e <vprintfmt+0xdf>
  8005e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ea:	85 c0                	test   %eax,%eax
  8005ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f1:	0f 49 c8             	cmovns %eax,%ecx
  8005f4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005fa:	eb 8c                	jmp    800588 <vprintfmt+0x59>
  8005fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005ff:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800606:	eb 80                	jmp    800588 <vprintfmt+0x59>
  800608:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80060b:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  80060e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800612:	0f 89 70 ff ff ff    	jns    800588 <vprintfmt+0x59>
				width = precision, precision = -1;
  800618:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80061b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80061e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800625:	e9 5e ff ff ff       	jmp    800588 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80062a:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80062d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800630:	e9 53 ff ff ff       	jmp    800588 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8d 50 04             	lea    0x4(%eax),%edx
  80063b:	89 55 14             	mov    %edx,0x14(%ebp)
  80063e:	83 ec 08             	sub    $0x8,%esp
  800641:	53                   	push   %ebx
  800642:	ff 30                	pushl  (%eax)
  800644:	ff d6                	call   *%esi
			break;
  800646:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800649:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  80064c:	e9 04 ff ff ff       	jmp    800555 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8d 50 04             	lea    0x4(%eax),%edx
  800657:	89 55 14             	mov    %edx,0x14(%ebp)
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	99                   	cltd   
  80065d:	31 d0                	xor    %edx,%eax
  80065f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800661:	83 f8 0f             	cmp    $0xf,%eax
  800664:	7f 0b                	jg     800671 <vprintfmt+0x142>
  800666:	8b 14 85 80 26 80 00 	mov    0x802680(,%eax,4),%edx
  80066d:	85 d2                	test   %edx,%edx
  80066f:	75 18                	jne    800689 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  800671:	50                   	push   %eax
  800672:	68 d3 23 80 00       	push   $0x8023d3
  800677:	53                   	push   %ebx
  800678:	56                   	push   %esi
  800679:	e8 94 fe ff ff       	call   800512 <printfmt>
  80067e:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800681:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800684:	e9 cc fe ff ff       	jmp    800555 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  800689:	52                   	push   %edx
  80068a:	68 b5 27 80 00       	push   $0x8027b5
  80068f:	53                   	push   %ebx
  800690:	56                   	push   %esi
  800691:	e8 7c fe ff ff       	call   800512 <printfmt>
  800696:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800699:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80069c:	e9 b4 fe ff ff       	jmp    800555 <vprintfmt+0x26>
  8006a1:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8006a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a7:	89 45 cc             	mov    %eax,-0x34(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8d 50 04             	lea    0x4(%eax),%edx
  8006b0:	89 55 14             	mov    %edx,0x14(%ebp)
  8006b3:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8006b5:	85 ff                	test   %edi,%edi
  8006b7:	ba cc 23 80 00       	mov    $0x8023cc,%edx
  8006bc:	0f 44 fa             	cmove  %edx,%edi
			if (width > 0 && padc != '-')
  8006bf:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8006c3:	0f 84 92 00 00 00    	je     80075b <vprintfmt+0x22c>
  8006c9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006cd:	0f 8e 96 00 00 00    	jle    800769 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d3:	83 ec 08             	sub    $0x8,%esp
  8006d6:	51                   	push   %ecx
  8006d7:	57                   	push   %edi
  8006d8:	e8 86 02 00 00       	call   800963 <strnlen>
  8006dd:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8006e0:	29 c1                	sub    %eax,%ecx
  8006e2:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8006e5:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006e8:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006ef:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006f2:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f4:	eb 0f                	jmp    800705 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	53                   	push   %ebx
  8006fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8006fd:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ff:	83 ef 01             	sub    $0x1,%edi
  800702:	83 c4 10             	add    $0x10,%esp
  800705:	85 ff                	test   %edi,%edi
  800707:	7f ed                	jg     8006f6 <vprintfmt+0x1c7>
  800709:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80070c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  80070f:	85 c9                	test   %ecx,%ecx
  800711:	b8 00 00 00 00       	mov    $0x0,%eax
  800716:	0f 49 c1             	cmovns %ecx,%eax
  800719:	29 c1                	sub    %eax,%ecx
  80071b:	89 75 08             	mov    %esi,0x8(%ebp)
  80071e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800721:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800724:	89 cb                	mov    %ecx,%ebx
  800726:	eb 4d                	jmp    800775 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800728:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80072c:	74 1b                	je     800749 <vprintfmt+0x21a>
  80072e:	0f be c0             	movsbl %al,%eax
  800731:	83 e8 20             	sub    $0x20,%eax
  800734:	83 f8 5e             	cmp    $0x5e,%eax
  800737:	76 10                	jbe    800749 <vprintfmt+0x21a>
					putch('?', putdat);
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	6a 3f                	push   $0x3f
  800741:	ff 55 08             	call   *0x8(%ebp)
  800744:	83 c4 10             	add    $0x10,%esp
  800747:	eb 0d                	jmp    800756 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	ff 75 0c             	pushl  0xc(%ebp)
  80074f:	52                   	push   %edx
  800750:	ff 55 08             	call   *0x8(%ebp)
  800753:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800756:	83 eb 01             	sub    $0x1,%ebx
  800759:	eb 1a                	jmp    800775 <vprintfmt+0x246>
  80075b:	89 75 08             	mov    %esi,0x8(%ebp)
  80075e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800761:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800764:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800767:	eb 0c                	jmp    800775 <vprintfmt+0x246>
  800769:	89 75 08             	mov    %esi,0x8(%ebp)
  80076c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80076f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800772:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800775:	83 c7 01             	add    $0x1,%edi
  800778:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80077c:	0f be d0             	movsbl %al,%edx
  80077f:	85 d2                	test   %edx,%edx
  800781:	74 23                	je     8007a6 <vprintfmt+0x277>
  800783:	85 f6                	test   %esi,%esi
  800785:	78 a1                	js     800728 <vprintfmt+0x1f9>
  800787:	83 ee 01             	sub    $0x1,%esi
  80078a:	79 9c                	jns    800728 <vprintfmt+0x1f9>
  80078c:	89 df                	mov    %ebx,%edi
  80078e:	8b 75 08             	mov    0x8(%ebp),%esi
  800791:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800794:	eb 18                	jmp    8007ae <vprintfmt+0x27f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	53                   	push   %ebx
  80079a:	6a 20                	push   $0x20
  80079c:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079e:	83 ef 01             	sub    $0x1,%edi
  8007a1:	83 c4 10             	add    $0x10,%esp
  8007a4:	eb 08                	jmp    8007ae <vprintfmt+0x27f>
  8007a6:	89 df                	mov    %ebx,%edi
  8007a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007ae:	85 ff                	test   %edi,%edi
  8007b0:	7f e4                	jg     800796 <vprintfmt+0x267>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007b5:	e9 9b fd ff ff       	jmp    800555 <vprintfmt+0x26>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007ba:	83 fa 01             	cmp    $0x1,%edx
  8007bd:	7e 16                	jle    8007d5 <vprintfmt+0x2a6>
		return va_arg(*ap, long long);
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8d 50 08             	lea    0x8(%eax),%edx
  8007c5:	89 55 14             	mov    %edx,0x14(%ebp)
  8007c8:	8b 50 04             	mov    0x4(%eax),%edx
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d3:	eb 32                	jmp    800807 <vprintfmt+0x2d8>
	else if (lflag)
  8007d5:	85 d2                	test   %edx,%edx
  8007d7:	74 18                	je     8007f1 <vprintfmt+0x2c2>
		return va_arg(*ap, long);
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8d 50 04             	lea    0x4(%eax),%edx
  8007df:	89 55 14             	mov    %edx,0x14(%ebp)
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e7:	89 c1                	mov    %eax,%ecx
  8007e9:	c1 f9 1f             	sar    $0x1f,%ecx
  8007ec:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007ef:	eb 16                	jmp    800807 <vprintfmt+0x2d8>
	else
		return va_arg(*ap, int);
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	8d 50 04             	lea    0x4(%eax),%edx
  8007f7:	89 55 14             	mov    %edx,0x14(%ebp)
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ff:	89 c1                	mov    %eax,%ecx
  800801:	c1 f9 1f             	sar    $0x1f,%ecx
  800804:	89 4d dc             	mov    %ecx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800807:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80080a:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80080d:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800812:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800816:	79 74                	jns    80088c <vprintfmt+0x35d>
				putch('-', putdat);
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	53                   	push   %ebx
  80081c:	6a 2d                	push   $0x2d
  80081e:	ff d6                	call   *%esi
				num = -(long long) num;
  800820:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800823:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800826:	f7 d8                	neg    %eax
  800828:	83 d2 00             	adc    $0x0,%edx
  80082b:	f7 da                	neg    %edx
  80082d:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800830:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800835:	eb 55                	jmp    80088c <vprintfmt+0x35d>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800837:	8d 45 14             	lea    0x14(%ebp),%eax
  80083a:	e8 7c fc ff ff       	call   8004bb <getuint>
			base = 10;
  80083f:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800844:	eb 46                	jmp    80088c <vprintfmt+0x35d>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800846:	8d 45 14             	lea    0x14(%ebp),%eax
  800849:	e8 6d fc ff ff       	call   8004bb <getuint>
                        base = 8;
  80084e:	b9 08 00 00 00       	mov    $0x8,%ecx
                        goto number;
  800853:	eb 37                	jmp    80088c <vprintfmt+0x35d>

		// pointer
		case 'p':
			putch('0', putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	53                   	push   %ebx
  800859:	6a 30                	push   $0x30
  80085b:	ff d6                	call   *%esi
			putch('x', putdat);
  80085d:	83 c4 08             	add    $0x8,%esp
  800860:	53                   	push   %ebx
  800861:	6a 78                	push   $0x78
  800863:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	8d 50 04             	lea    0x4(%eax),%edx
  80086b:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80086e:	8b 00                	mov    (%eax),%eax
  800870:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800875:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800878:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80087d:	eb 0d                	jmp    80088c <vprintfmt+0x35d>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80087f:	8d 45 14             	lea    0x14(%ebp),%eax
  800882:	e8 34 fc ff ff       	call   8004bb <getuint>
			base = 16;
  800887:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  80088c:	83 ec 0c             	sub    $0xc,%esp
  80088f:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800893:	57                   	push   %edi
  800894:	ff 75 e0             	pushl  -0x20(%ebp)
  800897:	51                   	push   %ecx
  800898:	52                   	push   %edx
  800899:	50                   	push   %eax
  80089a:	89 da                	mov    %ebx,%edx
  80089c:	89 f0                	mov    %esi,%eax
  80089e:	e8 6e fb ff ff       	call   800411 <printnum>
			break;
  8008a3:	83 c4 20             	add    $0x20,%esp
  8008a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8008a9:	e9 a7 fc ff ff       	jmp    800555 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	53                   	push   %ebx
  8008b2:	51                   	push   %ecx
  8008b3:	ff d6                	call   *%esi
			break;
  8008b5:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8008bb:	e9 95 fc ff ff       	jmp    800555 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	53                   	push   %ebx
  8008c4:	6a 25                	push   $0x25
  8008c6:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c8:	83 c4 10             	add    $0x10,%esp
  8008cb:	eb 03                	jmp    8008d0 <vprintfmt+0x3a1>
  8008cd:	83 ef 01             	sub    $0x1,%edi
  8008d0:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  8008d4:	75 f7                	jne    8008cd <vprintfmt+0x39e>
  8008d6:	e9 7a fc ff ff       	jmp    800555 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  8008db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008de:	5b                   	pop    %ebx
  8008df:	5e                   	pop    %esi
  8008e0:	5f                   	pop    %edi
  8008e1:	5d                   	pop    %ebp
  8008e2:	c3                   	ret    

008008e3 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	83 ec 18             	sub    $0x18,%esp
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008f6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800900:	85 c0                	test   %eax,%eax
  800902:	74 26                	je     80092a <vsnprintf+0x47>
  800904:	85 d2                	test   %edx,%edx
  800906:	7e 22                	jle    80092a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800908:	ff 75 14             	pushl  0x14(%ebp)
  80090b:	ff 75 10             	pushl  0x10(%ebp)
  80090e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800911:	50                   	push   %eax
  800912:	68 f5 04 80 00       	push   $0x8004f5
  800917:	e8 13 fc ff ff       	call   80052f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80091c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80091f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800925:	83 c4 10             	add    $0x10,%esp
  800928:	eb 05                	jmp    80092f <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80092a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80092f:	c9                   	leave  
  800930:	c3                   	ret    

00800931 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800937:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80093a:	50                   	push   %eax
  80093b:	ff 75 10             	pushl  0x10(%ebp)
  80093e:	ff 75 0c             	pushl  0xc(%ebp)
  800941:	ff 75 08             	pushl  0x8(%ebp)
  800944:	e8 9a ff ff ff       	call   8008e3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800949:	c9                   	leave  
  80094a:	c3                   	ret    

0080094b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800951:	b8 00 00 00 00       	mov    $0x0,%eax
  800956:	eb 03                	jmp    80095b <strlen+0x10>
		n++;
  800958:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80095b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80095f:	75 f7                	jne    800958 <strlen+0xd>
		n++;
	return n;
}
  800961:	5d                   	pop    %ebp
  800962:	c3                   	ret    

00800963 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800969:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80096c:	ba 00 00 00 00       	mov    $0x0,%edx
  800971:	eb 03                	jmp    800976 <strnlen+0x13>
		n++;
  800973:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800976:	39 c2                	cmp    %eax,%edx
  800978:	74 08                	je     800982 <strnlen+0x1f>
  80097a:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80097e:	75 f3                	jne    800973 <strnlen+0x10>
  800980:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	53                   	push   %ebx
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80098e:	89 c2                	mov    %eax,%edx
  800990:	83 c2 01             	add    $0x1,%edx
  800993:	83 c1 01             	add    $0x1,%ecx
  800996:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80099a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80099d:	84 db                	test   %bl,%bl
  80099f:	75 ef                	jne    800990 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009a1:	5b                   	pop    %ebx
  8009a2:	5d                   	pop    %ebp
  8009a3:	c3                   	ret    

008009a4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	53                   	push   %ebx
  8009a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009ab:	53                   	push   %ebx
  8009ac:	e8 9a ff ff ff       	call   80094b <strlen>
  8009b1:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8009b4:	ff 75 0c             	pushl  0xc(%ebp)
  8009b7:	01 d8                	add    %ebx,%eax
  8009b9:	50                   	push   %eax
  8009ba:	e8 c5 ff ff ff       	call   800984 <strcpy>
	return dst;
}
  8009bf:	89 d8                	mov    %ebx,%eax
  8009c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009c4:	c9                   	leave  
  8009c5:	c3                   	ret    

008009c6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009c6:	55                   	push   %ebp
  8009c7:	89 e5                	mov    %esp,%ebp
  8009c9:	56                   	push   %esi
  8009ca:	53                   	push   %ebx
  8009cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d1:	89 f3                	mov    %esi,%ebx
  8009d3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009d6:	89 f2                	mov    %esi,%edx
  8009d8:	eb 0f                	jmp    8009e9 <strncpy+0x23>
		*dst++ = *src;
  8009da:	83 c2 01             	add    $0x1,%edx
  8009dd:	0f b6 01             	movzbl (%ecx),%eax
  8009e0:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009e3:	80 39 01             	cmpb   $0x1,(%ecx)
  8009e6:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009e9:	39 da                	cmp    %ebx,%edx
  8009eb:	75 ed                	jne    8009da <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009ed:	89 f0                	mov    %esi,%eax
  8009ef:	5b                   	pop    %ebx
  8009f0:	5e                   	pop    %esi
  8009f1:	5d                   	pop    %ebp
  8009f2:	c3                   	ret    

008009f3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	56                   	push   %esi
  8009f7:	53                   	push   %ebx
  8009f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8009fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009fe:	8b 55 10             	mov    0x10(%ebp),%edx
  800a01:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a03:	85 d2                	test   %edx,%edx
  800a05:	74 21                	je     800a28 <strlcpy+0x35>
  800a07:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a0b:	89 f2                	mov    %esi,%edx
  800a0d:	eb 09                	jmp    800a18 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a0f:	83 c2 01             	add    $0x1,%edx
  800a12:	83 c1 01             	add    $0x1,%ecx
  800a15:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a18:	39 c2                	cmp    %eax,%edx
  800a1a:	74 09                	je     800a25 <strlcpy+0x32>
  800a1c:	0f b6 19             	movzbl (%ecx),%ebx
  800a1f:	84 db                	test   %bl,%bl
  800a21:	75 ec                	jne    800a0f <strlcpy+0x1c>
  800a23:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800a25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a28:	29 f0                	sub    %esi,%eax
}
  800a2a:	5b                   	pop    %ebx
  800a2b:	5e                   	pop    %esi
  800a2c:	5d                   	pop    %ebp
  800a2d:	c3                   	ret    

00800a2e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a34:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a37:	eb 06                	jmp    800a3f <strcmp+0x11>
		p++, q++;
  800a39:	83 c1 01             	add    $0x1,%ecx
  800a3c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a3f:	0f b6 01             	movzbl (%ecx),%eax
  800a42:	84 c0                	test   %al,%al
  800a44:	74 04                	je     800a4a <strcmp+0x1c>
  800a46:	3a 02                	cmp    (%edx),%al
  800a48:	74 ef                	je     800a39 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a4a:	0f b6 c0             	movzbl %al,%eax
  800a4d:	0f b6 12             	movzbl (%edx),%edx
  800a50:	29 d0                	sub    %edx,%eax
}
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	53                   	push   %ebx
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5e:	89 c3                	mov    %eax,%ebx
  800a60:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a63:	eb 06                	jmp    800a6b <strncmp+0x17>
		n--, p++, q++;
  800a65:	83 c0 01             	add    $0x1,%eax
  800a68:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a6b:	39 d8                	cmp    %ebx,%eax
  800a6d:	74 15                	je     800a84 <strncmp+0x30>
  800a6f:	0f b6 08             	movzbl (%eax),%ecx
  800a72:	84 c9                	test   %cl,%cl
  800a74:	74 04                	je     800a7a <strncmp+0x26>
  800a76:	3a 0a                	cmp    (%edx),%cl
  800a78:	74 eb                	je     800a65 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a7a:	0f b6 00             	movzbl (%eax),%eax
  800a7d:	0f b6 12             	movzbl (%edx),%edx
  800a80:	29 d0                	sub    %edx,%eax
  800a82:	eb 05                	jmp    800a89 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a84:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a89:	5b                   	pop    %ebx
  800a8a:	5d                   	pop    %ebp
  800a8b:	c3                   	ret    

00800a8c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a96:	eb 07                	jmp    800a9f <strchr+0x13>
		if (*s == c)
  800a98:	38 ca                	cmp    %cl,%dl
  800a9a:	74 0f                	je     800aab <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a9c:	83 c0 01             	add    $0x1,%eax
  800a9f:	0f b6 10             	movzbl (%eax),%edx
  800aa2:	84 d2                	test   %dl,%dl
  800aa4:	75 f2                	jne    800a98 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800aa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aab:	5d                   	pop    %ebp
  800aac:	c3                   	ret    

00800aad <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab7:	eb 03                	jmp    800abc <strfind+0xf>
  800ab9:	83 c0 01             	add    $0x1,%eax
  800abc:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800abf:	84 d2                	test   %dl,%dl
  800ac1:	74 04                	je     800ac7 <strfind+0x1a>
  800ac3:	38 ca                	cmp    %cl,%dl
  800ac5:	75 f2                	jne    800ab9 <strfind+0xc>
			break;
	return (char *) s;
}
  800ac7:	5d                   	pop    %ebp
  800ac8:	c3                   	ret    

00800ac9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	57                   	push   %edi
  800acd:	56                   	push   %esi
  800ace:	53                   	push   %ebx
  800acf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ad2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ad5:	85 c9                	test   %ecx,%ecx
  800ad7:	74 36                	je     800b0f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ad9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800adf:	75 28                	jne    800b09 <memset+0x40>
  800ae1:	f6 c1 03             	test   $0x3,%cl
  800ae4:	75 23                	jne    800b09 <memset+0x40>
		c &= 0xFF;
  800ae6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aea:	89 d3                	mov    %edx,%ebx
  800aec:	c1 e3 08             	shl    $0x8,%ebx
  800aef:	89 d6                	mov    %edx,%esi
  800af1:	c1 e6 18             	shl    $0x18,%esi
  800af4:	89 d0                	mov    %edx,%eax
  800af6:	c1 e0 10             	shl    $0x10,%eax
  800af9:	09 f0                	or     %esi,%eax
  800afb:	09 c2                	or     %eax,%edx
  800afd:	89 d0                	mov    %edx,%eax
  800aff:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b01:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b04:	fc                   	cld    
  800b05:	f3 ab                	rep stos %eax,%es:(%edi)
  800b07:	eb 06                	jmp    800b0f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0c:	fc                   	cld    
  800b0d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b0f:	89 f8                	mov    %edi,%eax
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5f                   	pop    %edi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	57                   	push   %edi
  800b1a:	56                   	push   %esi
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b21:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b24:	39 c6                	cmp    %eax,%esi
  800b26:	73 35                	jae    800b5d <memmove+0x47>
  800b28:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b2b:	39 d0                	cmp    %edx,%eax
  800b2d:	73 2e                	jae    800b5d <memmove+0x47>
		s += n;
		d += n;
  800b2f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b32:	89 d6                	mov    %edx,%esi
  800b34:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b36:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b3c:	75 13                	jne    800b51 <memmove+0x3b>
  800b3e:	f6 c1 03             	test   $0x3,%cl
  800b41:	75 0e                	jne    800b51 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b43:	83 ef 04             	sub    $0x4,%edi
  800b46:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b49:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b4c:	fd                   	std    
  800b4d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b4f:	eb 09                	jmp    800b5a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b51:	83 ef 01             	sub    $0x1,%edi
  800b54:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b57:	fd                   	std    
  800b58:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b5a:	fc                   	cld    
  800b5b:	eb 1d                	jmp    800b7a <memmove+0x64>
  800b5d:	89 f2                	mov    %esi,%edx
  800b5f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b61:	f6 c2 03             	test   $0x3,%dl
  800b64:	75 0f                	jne    800b75 <memmove+0x5f>
  800b66:	f6 c1 03             	test   $0x3,%cl
  800b69:	75 0a                	jne    800b75 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b6b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b6e:	89 c7                	mov    %eax,%edi
  800b70:	fc                   	cld    
  800b71:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b73:	eb 05                	jmp    800b7a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b75:	89 c7                	mov    %eax,%edi
  800b77:	fc                   	cld    
  800b78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b7a:	5e                   	pop    %esi
  800b7b:	5f                   	pop    %edi
  800b7c:	5d                   	pop    %ebp
  800b7d:	c3                   	ret    

00800b7e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b81:	ff 75 10             	pushl  0x10(%ebp)
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	ff 75 08             	pushl  0x8(%ebp)
  800b8a:	e8 87 ff ff ff       	call   800b16 <memmove>
}
  800b8f:	c9                   	leave  
  800b90:	c3                   	ret    

00800b91 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	56                   	push   %esi
  800b95:	53                   	push   %ebx
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9c:	89 c6                	mov    %eax,%esi
  800b9e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ba1:	eb 1a                	jmp    800bbd <memcmp+0x2c>
		if (*s1 != *s2)
  800ba3:	0f b6 08             	movzbl (%eax),%ecx
  800ba6:	0f b6 1a             	movzbl (%edx),%ebx
  800ba9:	38 d9                	cmp    %bl,%cl
  800bab:	74 0a                	je     800bb7 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800bad:	0f b6 c1             	movzbl %cl,%eax
  800bb0:	0f b6 db             	movzbl %bl,%ebx
  800bb3:	29 d8                	sub    %ebx,%eax
  800bb5:	eb 0f                	jmp    800bc6 <memcmp+0x35>
		s1++, s2++;
  800bb7:	83 c0 01             	add    $0x1,%eax
  800bba:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bbd:	39 f0                	cmp    %esi,%eax
  800bbf:	75 e2                	jne    800ba3 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc6:	5b                   	pop    %ebx
  800bc7:	5e                   	pop    %esi
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bd3:	89 c2                	mov    %eax,%edx
  800bd5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bd8:	eb 07                	jmp    800be1 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bda:	38 08                	cmp    %cl,(%eax)
  800bdc:	74 07                	je     800be5 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bde:	83 c0 01             	add    $0x1,%eax
  800be1:	39 d0                	cmp    %edx,%eax
  800be3:	72 f5                	jb     800bda <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	57                   	push   %edi
  800beb:	56                   	push   %esi
  800bec:	53                   	push   %ebx
  800bed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bf3:	eb 03                	jmp    800bf8 <strtol+0x11>
		s++;
  800bf5:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bf8:	0f b6 01             	movzbl (%ecx),%eax
  800bfb:	3c 09                	cmp    $0x9,%al
  800bfd:	74 f6                	je     800bf5 <strtol+0xe>
  800bff:	3c 20                	cmp    $0x20,%al
  800c01:	74 f2                	je     800bf5 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c03:	3c 2b                	cmp    $0x2b,%al
  800c05:	75 0a                	jne    800c11 <strtol+0x2a>
		s++;
  800c07:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c0a:	bf 00 00 00 00       	mov    $0x0,%edi
  800c0f:	eb 10                	jmp    800c21 <strtol+0x3a>
  800c11:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c16:	3c 2d                	cmp    $0x2d,%al
  800c18:	75 07                	jne    800c21 <strtol+0x3a>
		s++, neg = 1;
  800c1a:	8d 49 01             	lea    0x1(%ecx),%ecx
  800c1d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c21:	85 db                	test   %ebx,%ebx
  800c23:	0f 94 c0             	sete   %al
  800c26:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c2c:	75 19                	jne    800c47 <strtol+0x60>
  800c2e:	80 39 30             	cmpb   $0x30,(%ecx)
  800c31:	75 14                	jne    800c47 <strtol+0x60>
  800c33:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c37:	0f 85 82 00 00 00    	jne    800cbf <strtol+0xd8>
		s += 2, base = 16;
  800c3d:	83 c1 02             	add    $0x2,%ecx
  800c40:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c45:	eb 16                	jmp    800c5d <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c47:	84 c0                	test   %al,%al
  800c49:	74 12                	je     800c5d <strtol+0x76>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c4b:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c50:	80 39 30             	cmpb   $0x30,(%ecx)
  800c53:	75 08                	jne    800c5d <strtol+0x76>
		s++, base = 8;
  800c55:	83 c1 01             	add    $0x1,%ecx
  800c58:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c62:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c65:	0f b6 11             	movzbl (%ecx),%edx
  800c68:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c6b:	89 f3                	mov    %esi,%ebx
  800c6d:	80 fb 09             	cmp    $0x9,%bl
  800c70:	77 08                	ja     800c7a <strtol+0x93>
			dig = *s - '0';
  800c72:	0f be d2             	movsbl %dl,%edx
  800c75:	83 ea 30             	sub    $0x30,%edx
  800c78:	eb 22                	jmp    800c9c <strtol+0xb5>
		else if (*s >= 'a' && *s <= 'z')
  800c7a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c7d:	89 f3                	mov    %esi,%ebx
  800c7f:	80 fb 19             	cmp    $0x19,%bl
  800c82:	77 08                	ja     800c8c <strtol+0xa5>
			dig = *s - 'a' + 10;
  800c84:	0f be d2             	movsbl %dl,%edx
  800c87:	83 ea 57             	sub    $0x57,%edx
  800c8a:	eb 10                	jmp    800c9c <strtol+0xb5>
		else if (*s >= 'A' && *s <= 'Z')
  800c8c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c8f:	89 f3                	mov    %esi,%ebx
  800c91:	80 fb 19             	cmp    $0x19,%bl
  800c94:	77 16                	ja     800cac <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c96:	0f be d2             	movsbl %dl,%edx
  800c99:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800c9c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c9f:	7d 0f                	jge    800cb0 <strtol+0xc9>
			break;
		s++, val = (val * base) + dig;
  800ca1:	83 c1 01             	add    $0x1,%ecx
  800ca4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ca8:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800caa:	eb b9                	jmp    800c65 <strtol+0x7e>
  800cac:	89 c2                	mov    %eax,%edx
  800cae:	eb 02                	jmp    800cb2 <strtol+0xcb>
  800cb0:	89 c2                	mov    %eax,%edx

	if (endptr)
  800cb2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb6:	74 0d                	je     800cc5 <strtol+0xde>
		*endptr = (char *) s;
  800cb8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cbb:	89 0e                	mov    %ecx,(%esi)
  800cbd:	eb 06                	jmp    800cc5 <strtol+0xde>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cbf:	84 c0                	test   %al,%al
  800cc1:	75 92                	jne    800c55 <strtol+0x6e>
  800cc3:	eb 98                	jmp    800c5d <strtol+0x76>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800cc5:	f7 da                	neg    %edx
  800cc7:	85 ff                	test   %edi,%edi
  800cc9:	0f 45 c2             	cmovne %edx,%eax
}
  800ccc:	5b                   	pop    %ebx
  800ccd:	5e                   	pop    %esi
  800cce:	5f                   	pop    %edi
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    

00800cd1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	57                   	push   %edi
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cd7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce2:	89 c3                	mov    %eax,%ebx
  800ce4:	89 c7                	mov    %eax,%edi
  800ce6:	89 c6                	mov    %eax,%esi
  800ce8:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cea:	5b                   	pop    %ebx
  800ceb:	5e                   	pop    %esi
  800cec:	5f                   	pop    %edi
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    

00800cef <sys_cgetc>:

int
sys_cgetc(void)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	57                   	push   %edi
  800cf3:	56                   	push   %esi
  800cf4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfa:	b8 01 00 00 00       	mov    $0x1,%eax
  800cff:	89 d1                	mov    %edx,%ecx
  800d01:	89 d3                	mov    %edx,%ebx
  800d03:	89 d7                	mov    %edx,%edi
  800d05:	89 d6                	mov    %edx,%esi
  800d07:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d09:	5b                   	pop    %ebx
  800d0a:	5e                   	pop    %esi
  800d0b:	5f                   	pop    %edi
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    

00800d0e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	57                   	push   %edi
  800d12:	56                   	push   %esi
  800d13:	53                   	push   %ebx
  800d14:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d17:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d1c:	b8 03 00 00 00       	mov    $0x3,%eax
  800d21:	8b 55 08             	mov    0x8(%ebp),%edx
  800d24:	89 cb                	mov    %ecx,%ebx
  800d26:	89 cf                	mov    %ecx,%edi
  800d28:	89 ce                	mov    %ecx,%esi
  800d2a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d2c:	85 c0                	test   %eax,%eax
  800d2e:	7e 17                	jle    800d47 <sys_env_destroy+0x39>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d30:	83 ec 0c             	sub    $0xc,%esp
  800d33:	50                   	push   %eax
  800d34:	6a 03                	push   $0x3
  800d36:	68 df 26 80 00       	push   $0x8026df
  800d3b:	6a 23                	push   $0x23
  800d3d:	68 fc 26 80 00       	push   $0x8026fc
  800d42:	e8 dd f5 ff ff       	call   800324 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4a:	5b                   	pop    %ebx
  800d4b:	5e                   	pop    %esi
  800d4c:	5f                   	pop    %edi
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    

00800d4f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	57                   	push   %edi
  800d53:	56                   	push   %esi
  800d54:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d55:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5a:	b8 02 00 00 00       	mov    $0x2,%eax
  800d5f:	89 d1                	mov    %edx,%ecx
  800d61:	89 d3                	mov    %edx,%ebx
  800d63:	89 d7                	mov    %edx,%edi
  800d65:	89 d6                	mov    %edx,%esi
  800d67:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d69:	5b                   	pop    %ebx
  800d6a:	5e                   	pop    %esi
  800d6b:	5f                   	pop    %edi
  800d6c:	5d                   	pop    %ebp
  800d6d:	c3                   	ret    

00800d6e <sys_yield>:

void
sys_yield(void)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d74:	ba 00 00 00 00       	mov    $0x0,%edx
  800d79:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d7e:	89 d1                	mov    %edx,%ecx
  800d80:	89 d3                	mov    %edx,%ebx
  800d82:	89 d7                	mov    %edx,%edi
  800d84:	89 d6                	mov    %edx,%esi
  800d86:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	57                   	push   %edi
  800d91:	56                   	push   %esi
  800d92:	53                   	push   %ebx
  800d93:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d96:	be 00 00 00 00       	mov    $0x0,%esi
  800d9b:	b8 04 00 00 00       	mov    $0x4,%eax
  800da0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da3:	8b 55 08             	mov    0x8(%ebp),%edx
  800da6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da9:	89 f7                	mov    %esi,%edi
  800dab:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dad:	85 c0                	test   %eax,%eax
  800daf:	7e 17                	jle    800dc8 <sys_page_alloc+0x3b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db1:	83 ec 0c             	sub    $0xc,%esp
  800db4:	50                   	push   %eax
  800db5:	6a 04                	push   $0x4
  800db7:	68 df 26 80 00       	push   $0x8026df
  800dbc:	6a 23                	push   $0x23
  800dbe:	68 fc 26 80 00       	push   $0x8026fc
  800dc3:	e8 5c f5 ff ff       	call   800324 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dcb:	5b                   	pop    %ebx
  800dcc:	5e                   	pop    %esi
  800dcd:	5f                   	pop    %edi
  800dce:	5d                   	pop    %ebp
  800dcf:	c3                   	ret    

00800dd0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	57                   	push   %edi
  800dd4:	56                   	push   %esi
  800dd5:	53                   	push   %ebx
  800dd6:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd9:	b8 05 00 00 00       	mov    $0x5,%eax
  800dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de1:	8b 55 08             	mov    0x8(%ebp),%edx
  800de4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dea:	8b 75 18             	mov    0x18(%ebp),%esi
  800ded:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800def:	85 c0                	test   %eax,%eax
  800df1:	7e 17                	jle    800e0a <sys_page_map+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df3:	83 ec 0c             	sub    $0xc,%esp
  800df6:	50                   	push   %eax
  800df7:	6a 05                	push   $0x5
  800df9:	68 df 26 80 00       	push   $0x8026df
  800dfe:	6a 23                	push   $0x23
  800e00:	68 fc 26 80 00       	push   $0x8026fc
  800e05:	e8 1a f5 ff ff       	call   800324 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0d:	5b                   	pop    %ebx
  800e0e:	5e                   	pop    %esi
  800e0f:	5f                   	pop    %edi
  800e10:	5d                   	pop    %ebp
  800e11:	c3                   	ret    

00800e12 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	57                   	push   %edi
  800e16:	56                   	push   %esi
  800e17:	53                   	push   %ebx
  800e18:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e20:	b8 06 00 00 00       	mov    $0x6,%eax
  800e25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	89 df                	mov    %ebx,%edi
  800e2d:	89 de                	mov    %ebx,%esi
  800e2f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e31:	85 c0                	test   %eax,%eax
  800e33:	7e 17                	jle    800e4c <sys_page_unmap+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e35:	83 ec 0c             	sub    $0xc,%esp
  800e38:	50                   	push   %eax
  800e39:	6a 06                	push   $0x6
  800e3b:	68 df 26 80 00       	push   $0x8026df
  800e40:	6a 23                	push   $0x23
  800e42:	68 fc 26 80 00       	push   $0x8026fc
  800e47:	e8 d8 f4 ff ff       	call   800324 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4f:	5b                   	pop    %ebx
  800e50:	5e                   	pop    %esi
  800e51:	5f                   	pop    %edi
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    

00800e54 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	57                   	push   %edi
  800e58:	56                   	push   %esi
  800e59:	53                   	push   %ebx
  800e5a:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e62:	b8 08 00 00 00       	mov    $0x8,%eax
  800e67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6d:	89 df                	mov    %ebx,%edi
  800e6f:	89 de                	mov    %ebx,%esi
  800e71:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e73:	85 c0                	test   %eax,%eax
  800e75:	7e 17                	jle    800e8e <sys_env_set_status+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e77:	83 ec 0c             	sub    $0xc,%esp
  800e7a:	50                   	push   %eax
  800e7b:	6a 08                	push   $0x8
  800e7d:	68 df 26 80 00       	push   $0x8026df
  800e82:	6a 23                	push   $0x23
  800e84:	68 fc 26 80 00       	push   $0x8026fc
  800e89:	e8 96 f4 ff ff       	call   800324 <_panic>
sys_env_set_status(envid_t envid, int status)
{

	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
             
}
  800e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5f                   	pop    %edi
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    

00800e96 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	57                   	push   %edi
  800e9a:	56                   	push   %esi
  800e9b:	53                   	push   %ebx
  800e9c:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea4:	b8 09 00 00 00       	mov    $0x9,%eax
  800ea9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eac:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaf:	89 df                	mov    %ebx,%edi
  800eb1:	89 de                	mov    %ebx,%esi
  800eb3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	7e 17                	jle    800ed0 <sys_env_set_trapframe+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb9:	83 ec 0c             	sub    $0xc,%esp
  800ebc:	50                   	push   %eax
  800ebd:	6a 09                	push   $0x9
  800ebf:	68 df 26 80 00       	push   $0x8026df
  800ec4:	6a 23                	push   $0x23
  800ec6:	68 fc 26 80 00       	push   $0x8026fc
  800ecb:	e8 54 f4 ff ff       	call   800324 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed3:	5b                   	pop    %ebx
  800ed4:	5e                   	pop    %esi
  800ed5:	5f                   	pop    %edi
  800ed6:	5d                   	pop    %ebp
  800ed7:	c3                   	ret    

00800ed8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	57                   	push   %edi
  800edc:	56                   	push   %esi
  800edd:	53                   	push   %ebx
  800ede:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eeb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eee:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef1:	89 df                	mov    %ebx,%edi
  800ef3:	89 de                	mov    %ebx,%esi
  800ef5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef7:	85 c0                	test   %eax,%eax
  800ef9:	7e 17                	jle    800f12 <sys_env_set_pgfault_upcall+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800efb:	83 ec 0c             	sub    $0xc,%esp
  800efe:	50                   	push   %eax
  800eff:	6a 0a                	push   $0xa
  800f01:	68 df 26 80 00       	push   $0x8026df
  800f06:	6a 23                	push   $0x23
  800f08:	68 fc 26 80 00       	push   $0x8026fc
  800f0d:	e8 12 f4 ff ff       	call   800324 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f15:	5b                   	pop    %ebx
  800f16:	5e                   	pop    %esi
  800f17:	5f                   	pop    %edi
  800f18:	5d                   	pop    %ebp
  800f19:	c3                   	ret    

00800f1a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	57                   	push   %edi
  800f1e:	56                   	push   %esi
  800f1f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f20:	be 00 00 00 00       	mov    $0x0,%esi
  800f25:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f30:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f33:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f36:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f38:	5b                   	pop    %ebx
  800f39:	5e                   	pop    %esi
  800f3a:	5f                   	pop    %edi
  800f3b:	5d                   	pop    %ebp
  800f3c:	c3                   	ret    

00800f3d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	57                   	push   %edi
  800f41:	56                   	push   %esi
  800f42:	53                   	push   %ebx
  800f43:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f46:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f4b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f50:	8b 55 08             	mov    0x8(%ebp),%edx
  800f53:	89 cb                	mov    %ecx,%ebx
  800f55:	89 cf                	mov    %ecx,%edi
  800f57:	89 ce                	mov    %ecx,%esi
  800f59:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f5b:	85 c0                	test   %eax,%eax
  800f5d:	7e 17                	jle    800f76 <sys_ipc_recv+0x39>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5f:	83 ec 0c             	sub    $0xc,%esp
  800f62:	50                   	push   %eax
  800f63:	6a 0d                	push   $0xd
  800f65:	68 df 26 80 00       	push   $0x8026df
  800f6a:	6a 23                	push   $0x23
  800f6c:	68 fc 26 80 00       	push   $0x8026fc
  800f71:	e8 ae f3 ff ff       	call   800324 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f79:	5b                   	pop    %ebx
  800f7a:	5e                   	pop    %esi
  800f7b:	5f                   	pop    %edi
  800f7c:	5d                   	pop    %ebp
  800f7d:	c3                   	ret    

00800f7e <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	8b 55 08             	mov    0x8(%ebp),%edx
  800f84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f87:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800f8a:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800f8c:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800f8f:	83 3a 01             	cmpl   $0x1,(%edx)
  800f92:	7e 09                	jle    800f9d <argstart+0x1f>
  800f94:	ba 68 23 80 00       	mov    $0x802368,%edx
  800f99:	85 c9                	test   %ecx,%ecx
  800f9b:	75 05                	jne    800fa2 <argstart+0x24>
  800f9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa2:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800fa5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800fac:	5d                   	pop    %ebp
  800fad:	c3                   	ret    

00800fae <argnext>:

int
argnext(struct Argstate *args)
{
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
  800fb1:	53                   	push   %ebx
  800fb2:	83 ec 04             	sub    $0x4,%esp
  800fb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800fb8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800fbf:	8b 43 08             	mov    0x8(%ebx),%eax
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	74 6f                	je     801035 <argnext+0x87>
		return -1;

	if (!*args->curarg) {
  800fc6:	80 38 00             	cmpb   $0x0,(%eax)
  800fc9:	75 4e                	jne    801019 <argnext+0x6b>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  800fcb:	8b 0b                	mov    (%ebx),%ecx
  800fcd:	83 39 01             	cmpl   $0x1,(%ecx)
  800fd0:	74 55                	je     801027 <argnext+0x79>
		    || args->argv[1][0] != '-'
  800fd2:	8b 53 04             	mov    0x4(%ebx),%edx
  800fd5:	8b 42 04             	mov    0x4(%edx),%eax
  800fd8:	80 38 2d             	cmpb   $0x2d,(%eax)
  800fdb:	75 4a                	jne    801027 <argnext+0x79>
		    || args->argv[1][1] == '\0')
  800fdd:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800fe1:	74 44                	je     801027 <argnext+0x79>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  800fe3:	83 c0 01             	add    $0x1,%eax
  800fe6:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800fe9:	83 ec 04             	sub    $0x4,%esp
  800fec:	8b 01                	mov    (%ecx),%eax
  800fee:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  800ff5:	50                   	push   %eax
  800ff6:	8d 42 08             	lea    0x8(%edx),%eax
  800ff9:	50                   	push   %eax
  800ffa:	83 c2 04             	add    $0x4,%edx
  800ffd:	52                   	push   %edx
  800ffe:	e8 13 fb ff ff       	call   800b16 <memmove>
		(*args->argc)--;
  801003:	8b 03                	mov    (%ebx),%eax
  801005:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801008:	8b 43 08             	mov    0x8(%ebx),%eax
  80100b:	83 c4 10             	add    $0x10,%esp
  80100e:	80 38 2d             	cmpb   $0x2d,(%eax)
  801011:	75 06                	jne    801019 <argnext+0x6b>
  801013:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801017:	74 0e                	je     801027 <argnext+0x79>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801019:	8b 53 08             	mov    0x8(%ebx),%edx
  80101c:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  80101f:	83 c2 01             	add    $0x1,%edx
  801022:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  801025:	eb 13                	jmp    80103a <argnext+0x8c>

    endofargs:
	args->curarg = 0;
  801027:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  80102e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801033:	eb 05                	jmp    80103a <argnext+0x8c>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  801035:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  80103a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80103d:	c9                   	leave  
  80103e:	c3                   	ret    

0080103f <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  80103f:	55                   	push   %ebp
  801040:	89 e5                	mov    %esp,%ebp
  801042:	53                   	push   %ebx
  801043:	83 ec 04             	sub    $0x4,%esp
  801046:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801049:	8b 43 08             	mov    0x8(%ebx),%eax
  80104c:	85 c0                	test   %eax,%eax
  80104e:	74 58                	je     8010a8 <argnextvalue+0x69>
		return 0;
	if (*args->curarg) {
  801050:	80 38 00             	cmpb   $0x0,(%eax)
  801053:	74 0c                	je     801061 <argnextvalue+0x22>
		args->argvalue = args->curarg;
  801055:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801058:	c7 43 08 68 23 80 00 	movl   $0x802368,0x8(%ebx)
  80105f:	eb 42                	jmp    8010a3 <argnextvalue+0x64>
	} else if (*args->argc > 1) {
  801061:	8b 13                	mov    (%ebx),%edx
  801063:	83 3a 01             	cmpl   $0x1,(%edx)
  801066:	7e 2d                	jle    801095 <argnextvalue+0x56>
		args->argvalue = args->argv[1];
  801068:	8b 43 04             	mov    0x4(%ebx),%eax
  80106b:	8b 48 04             	mov    0x4(%eax),%ecx
  80106e:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801071:	83 ec 04             	sub    $0x4,%esp
  801074:	8b 12                	mov    (%edx),%edx
  801076:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  80107d:	52                   	push   %edx
  80107e:	8d 50 08             	lea    0x8(%eax),%edx
  801081:	52                   	push   %edx
  801082:	83 c0 04             	add    $0x4,%eax
  801085:	50                   	push   %eax
  801086:	e8 8b fa ff ff       	call   800b16 <memmove>
		(*args->argc)--;
  80108b:	8b 03                	mov    (%ebx),%eax
  80108d:	83 28 01             	subl   $0x1,(%eax)
  801090:	83 c4 10             	add    $0x10,%esp
  801093:	eb 0e                	jmp    8010a3 <argnextvalue+0x64>
	} else {
		args->argvalue = 0;
  801095:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  80109c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  8010a3:	8b 43 0c             	mov    0xc(%ebx),%eax
  8010a6:	eb 05                	jmp    8010ad <argnextvalue+0x6e>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  8010a8:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  8010ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010b0:	c9                   	leave  
  8010b1:	c3                   	ret    

008010b2 <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 08             	sub    $0x8,%esp
  8010b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8010bb:	8b 51 0c             	mov    0xc(%ecx),%edx
  8010be:	89 d0                	mov    %edx,%eax
  8010c0:	85 d2                	test   %edx,%edx
  8010c2:	75 0c                	jne    8010d0 <argvalue+0x1e>
  8010c4:	83 ec 0c             	sub    $0xc,%esp
  8010c7:	51                   	push   %ecx
  8010c8:	e8 72 ff ff ff       	call   80103f <argnextvalue>
  8010cd:	83 c4 10             	add    $0x10,%esp
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	05 00 00 00 30       	add    $0x30000000,%eax
  8010dd:	c1 e8 0c             	shr    $0xc,%eax
}
  8010e0:	5d                   	pop    %ebp
  8010e1:	c3                   	ret    

008010e2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8010ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010f2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010f7:	5d                   	pop    %ebp
  8010f8:	c3                   	ret    

008010f9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ff:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801104:	89 c2                	mov    %eax,%edx
  801106:	c1 ea 16             	shr    $0x16,%edx
  801109:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801110:	f6 c2 01             	test   $0x1,%dl
  801113:	74 11                	je     801126 <fd_alloc+0x2d>
  801115:	89 c2                	mov    %eax,%edx
  801117:	c1 ea 0c             	shr    $0xc,%edx
  80111a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801121:	f6 c2 01             	test   $0x1,%dl
  801124:	75 09                	jne    80112f <fd_alloc+0x36>
			*fd_store = fd;
  801126:	89 01                	mov    %eax,(%ecx)
			return 0;
  801128:	b8 00 00 00 00       	mov    $0x0,%eax
  80112d:	eb 17                	jmp    801146 <fd_alloc+0x4d>
  80112f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801134:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801139:	75 c9                	jne    801104 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80113b:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801141:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801146:	5d                   	pop    %ebp
  801147:	c3                   	ret    

00801148 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80114e:	83 f8 1f             	cmp    $0x1f,%eax
  801151:	77 36                	ja     801189 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801153:	c1 e0 0c             	shl    $0xc,%eax
  801156:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80115b:	89 c2                	mov    %eax,%edx
  80115d:	c1 ea 16             	shr    $0x16,%edx
  801160:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801167:	f6 c2 01             	test   $0x1,%dl
  80116a:	74 24                	je     801190 <fd_lookup+0x48>
  80116c:	89 c2                	mov    %eax,%edx
  80116e:	c1 ea 0c             	shr    $0xc,%edx
  801171:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801178:	f6 c2 01             	test   $0x1,%dl
  80117b:	74 1a                	je     801197 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80117d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801180:	89 02                	mov    %eax,(%edx)
	return 0;
  801182:	b8 00 00 00 00       	mov    $0x0,%eax
  801187:	eb 13                	jmp    80119c <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801189:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80118e:	eb 0c                	jmp    80119c <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801190:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801195:	eb 05                	jmp    80119c <fd_lookup+0x54>
  801197:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80119c:	5d                   	pop    %ebp
  80119d:	c3                   	ret    

0080119e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	83 ec 08             	sub    $0x8,%esp
  8011a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a7:	ba 8c 27 80 00       	mov    $0x80278c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8011ac:	eb 13                	jmp    8011c1 <dev_lookup+0x23>
  8011ae:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  8011b1:	39 08                	cmp    %ecx,(%eax)
  8011b3:	75 0c                	jne    8011c1 <dev_lookup+0x23>
			*dev = devtab[i];
  8011b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bf:	eb 2e                	jmp    8011ef <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011c1:	8b 02                	mov    (%edx),%eax
  8011c3:	85 c0                	test   %eax,%eax
  8011c5:	75 e7                	jne    8011ae <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011c7:	a1 40 44 80 00       	mov    0x804440,%eax
  8011cc:	8b 40 48             	mov    0x48(%eax),%eax
  8011cf:	83 ec 04             	sub    $0x4,%esp
  8011d2:	51                   	push   %ecx
  8011d3:	50                   	push   %eax
  8011d4:	68 0c 27 80 00       	push   $0x80270c
  8011d9:	e8 1f f2 ff ff       	call   8003fd <cprintf>
	*dev = 0;
  8011de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011e7:	83 c4 10             	add    $0x10,%esp
  8011ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011ef:	c9                   	leave  
  8011f0:	c3                   	ret    

008011f1 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	56                   	push   %esi
  8011f5:	53                   	push   %ebx
  8011f6:	83 ec 10             	sub    $0x10,%esp
  8011f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8011fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801202:	50                   	push   %eax
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801203:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801209:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80120c:	50                   	push   %eax
  80120d:	e8 36 ff ff ff       	call   801148 <fd_lookup>
  801212:	83 c4 08             	add    $0x8,%esp
  801215:	85 c0                	test   %eax,%eax
  801217:	78 05                	js     80121e <fd_close+0x2d>
	    || fd != fd2)
  801219:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80121c:	74 0c                	je     80122a <fd_close+0x39>
		return (must_exist ? r : 0);
  80121e:	84 db                	test   %bl,%bl
  801220:	ba 00 00 00 00       	mov    $0x0,%edx
  801225:	0f 44 c2             	cmove  %edx,%eax
  801228:	eb 41                	jmp    80126b <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80122a:	83 ec 08             	sub    $0x8,%esp
  80122d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801230:	50                   	push   %eax
  801231:	ff 36                	pushl  (%esi)
  801233:	e8 66 ff ff ff       	call   80119e <dev_lookup>
  801238:	89 c3                	mov    %eax,%ebx
  80123a:	83 c4 10             	add    $0x10,%esp
  80123d:	85 c0                	test   %eax,%eax
  80123f:	78 1a                	js     80125b <fd_close+0x6a>
		if (dev->dev_close)
  801241:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801244:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801247:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80124c:	85 c0                	test   %eax,%eax
  80124e:	74 0b                	je     80125b <fd_close+0x6a>
			r = (*dev->dev_close)(fd);
  801250:	83 ec 0c             	sub    $0xc,%esp
  801253:	56                   	push   %esi
  801254:	ff d0                	call   *%eax
  801256:	89 c3                	mov    %eax,%ebx
  801258:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80125b:	83 ec 08             	sub    $0x8,%esp
  80125e:	56                   	push   %esi
  80125f:	6a 00                	push   $0x0
  801261:	e8 ac fb ff ff       	call   800e12 <sys_page_unmap>
	return r;
  801266:	83 c4 10             	add    $0x10,%esp
  801269:	89 d8                	mov    %ebx,%eax
}
  80126b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80126e:	5b                   	pop    %ebx
  80126f:	5e                   	pop    %esi
  801270:	5d                   	pop    %ebp
  801271:	c3                   	ret    

00801272 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801278:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80127b:	50                   	push   %eax
  80127c:	ff 75 08             	pushl  0x8(%ebp)
  80127f:	e8 c4 fe ff ff       	call   801148 <fd_lookup>
  801284:	89 c2                	mov    %eax,%edx
  801286:	83 c4 08             	add    $0x8,%esp
  801289:	85 d2                	test   %edx,%edx
  80128b:	78 10                	js     80129d <close+0x2b>
		return r;
	else
		return fd_close(fd, 1);
  80128d:	83 ec 08             	sub    $0x8,%esp
  801290:	6a 01                	push   $0x1
  801292:	ff 75 f4             	pushl  -0xc(%ebp)
  801295:	e8 57 ff ff ff       	call   8011f1 <fd_close>
  80129a:	83 c4 10             	add    $0x10,%esp
}
  80129d:	c9                   	leave  
  80129e:	c3                   	ret    

0080129f <close_all>:

void
close_all(void)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
  8012a2:	53                   	push   %ebx
  8012a3:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012ab:	83 ec 0c             	sub    $0xc,%esp
  8012ae:	53                   	push   %ebx
  8012af:	e8 be ff ff ff       	call   801272 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8012b4:	83 c3 01             	add    $0x1,%ebx
  8012b7:	83 c4 10             	add    $0x10,%esp
  8012ba:	83 fb 20             	cmp    $0x20,%ebx
  8012bd:	75 ec                	jne    8012ab <close_all+0xc>
		close(i);
}
  8012bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c2:	c9                   	leave  
  8012c3:	c3                   	ret    

008012c4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	57                   	push   %edi
  8012c8:	56                   	push   %esi
  8012c9:	53                   	push   %ebx
  8012ca:	83 ec 2c             	sub    $0x2c,%esp
  8012cd:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012d3:	50                   	push   %eax
  8012d4:	ff 75 08             	pushl  0x8(%ebp)
  8012d7:	e8 6c fe ff ff       	call   801148 <fd_lookup>
  8012dc:	89 c2                	mov    %eax,%edx
  8012de:	83 c4 08             	add    $0x8,%esp
  8012e1:	85 d2                	test   %edx,%edx
  8012e3:	0f 88 c1 00 00 00    	js     8013aa <dup+0xe6>
		return r;
	close(newfdnum);
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	56                   	push   %esi
  8012ed:	e8 80 ff ff ff       	call   801272 <close>

	newfd = INDEX2FD(newfdnum);
  8012f2:	89 f3                	mov    %esi,%ebx
  8012f4:	c1 e3 0c             	shl    $0xc,%ebx
  8012f7:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8012fd:	83 c4 04             	add    $0x4,%esp
  801300:	ff 75 e4             	pushl  -0x1c(%ebp)
  801303:	e8 da fd ff ff       	call   8010e2 <fd2data>
  801308:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  80130a:	89 1c 24             	mov    %ebx,(%esp)
  80130d:	e8 d0 fd ff ff       	call   8010e2 <fd2data>
  801312:	83 c4 10             	add    $0x10,%esp
  801315:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801318:	89 f8                	mov    %edi,%eax
  80131a:	c1 e8 16             	shr    $0x16,%eax
  80131d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801324:	a8 01                	test   $0x1,%al
  801326:	74 37                	je     80135f <dup+0x9b>
  801328:	89 f8                	mov    %edi,%eax
  80132a:	c1 e8 0c             	shr    $0xc,%eax
  80132d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801334:	f6 c2 01             	test   $0x1,%dl
  801337:	74 26                	je     80135f <dup+0x9b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801339:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801340:	83 ec 0c             	sub    $0xc,%esp
  801343:	25 07 0e 00 00       	and    $0xe07,%eax
  801348:	50                   	push   %eax
  801349:	ff 75 d4             	pushl  -0x2c(%ebp)
  80134c:	6a 00                	push   $0x0
  80134e:	57                   	push   %edi
  80134f:	6a 00                	push   $0x0
  801351:	e8 7a fa ff ff       	call   800dd0 <sys_page_map>
  801356:	89 c7                	mov    %eax,%edi
  801358:	83 c4 20             	add    $0x20,%esp
  80135b:	85 c0                	test   %eax,%eax
  80135d:	78 2e                	js     80138d <dup+0xc9>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80135f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801362:	89 d0                	mov    %edx,%eax
  801364:	c1 e8 0c             	shr    $0xc,%eax
  801367:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80136e:	83 ec 0c             	sub    $0xc,%esp
  801371:	25 07 0e 00 00       	and    $0xe07,%eax
  801376:	50                   	push   %eax
  801377:	53                   	push   %ebx
  801378:	6a 00                	push   $0x0
  80137a:	52                   	push   %edx
  80137b:	6a 00                	push   $0x0
  80137d:	e8 4e fa ff ff       	call   800dd0 <sys_page_map>
  801382:	89 c7                	mov    %eax,%edi
  801384:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  801387:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801389:	85 ff                	test   %edi,%edi
  80138b:	79 1d                	jns    8013aa <dup+0xe6>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80138d:	83 ec 08             	sub    $0x8,%esp
  801390:	53                   	push   %ebx
  801391:	6a 00                	push   $0x0
  801393:	e8 7a fa ff ff       	call   800e12 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801398:	83 c4 08             	add    $0x8,%esp
  80139b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80139e:	6a 00                	push   $0x0
  8013a0:	e8 6d fa ff ff       	call   800e12 <sys_page_unmap>
	return r;
  8013a5:	83 c4 10             	add    $0x10,%esp
  8013a8:	89 f8                	mov    %edi,%eax
}
  8013aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ad:	5b                   	pop    %ebx
  8013ae:	5e                   	pop    %esi
  8013af:	5f                   	pop    %edi
  8013b0:	5d                   	pop    %ebp
  8013b1:	c3                   	ret    

008013b2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
  8013b5:	53                   	push   %ebx
  8013b6:	83 ec 14             	sub    $0x14,%esp
  8013b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013bf:	50                   	push   %eax
  8013c0:	53                   	push   %ebx
  8013c1:	e8 82 fd ff ff       	call   801148 <fd_lookup>
  8013c6:	83 c4 08             	add    $0x8,%esp
  8013c9:	89 c2                	mov    %eax,%edx
  8013cb:	85 c0                	test   %eax,%eax
  8013cd:	78 6d                	js     80143c <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013cf:	83 ec 08             	sub    $0x8,%esp
  8013d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d5:	50                   	push   %eax
  8013d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d9:	ff 30                	pushl  (%eax)
  8013db:	e8 be fd ff ff       	call   80119e <dev_lookup>
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	85 c0                	test   %eax,%eax
  8013e5:	78 4c                	js     801433 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013ea:	8b 42 08             	mov    0x8(%edx),%eax
  8013ed:	83 e0 03             	and    $0x3,%eax
  8013f0:	83 f8 01             	cmp    $0x1,%eax
  8013f3:	75 21                	jne    801416 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013f5:	a1 40 44 80 00       	mov    0x804440,%eax
  8013fa:	8b 40 48             	mov    0x48(%eax),%eax
  8013fd:	83 ec 04             	sub    $0x4,%esp
  801400:	53                   	push   %ebx
  801401:	50                   	push   %eax
  801402:	68 50 27 80 00       	push   $0x802750
  801407:	e8 f1 ef ff ff       	call   8003fd <cprintf>
		return -E_INVAL;
  80140c:	83 c4 10             	add    $0x10,%esp
  80140f:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801414:	eb 26                	jmp    80143c <read+0x8a>
	}
	if (!dev->dev_read)
  801416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801419:	8b 40 08             	mov    0x8(%eax),%eax
  80141c:	85 c0                	test   %eax,%eax
  80141e:	74 17                	je     801437 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801420:	83 ec 04             	sub    $0x4,%esp
  801423:	ff 75 10             	pushl  0x10(%ebp)
  801426:	ff 75 0c             	pushl  0xc(%ebp)
  801429:	52                   	push   %edx
  80142a:	ff d0                	call   *%eax
  80142c:	89 c2                	mov    %eax,%edx
  80142e:	83 c4 10             	add    $0x10,%esp
  801431:	eb 09                	jmp    80143c <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801433:	89 c2                	mov    %eax,%edx
  801435:	eb 05                	jmp    80143c <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801437:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  80143c:	89 d0                	mov    %edx,%eax
  80143e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	57                   	push   %edi
  801447:	56                   	push   %esi
  801448:	53                   	push   %ebx
  801449:	83 ec 0c             	sub    $0xc,%esp
  80144c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80144f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801452:	bb 00 00 00 00       	mov    $0x0,%ebx
  801457:	eb 21                	jmp    80147a <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801459:	83 ec 04             	sub    $0x4,%esp
  80145c:	89 f0                	mov    %esi,%eax
  80145e:	29 d8                	sub    %ebx,%eax
  801460:	50                   	push   %eax
  801461:	89 d8                	mov    %ebx,%eax
  801463:	03 45 0c             	add    0xc(%ebp),%eax
  801466:	50                   	push   %eax
  801467:	57                   	push   %edi
  801468:	e8 45 ff ff ff       	call   8013b2 <read>
		if (m < 0)
  80146d:	83 c4 10             	add    $0x10,%esp
  801470:	85 c0                	test   %eax,%eax
  801472:	78 0c                	js     801480 <readn+0x3d>
			return m;
		if (m == 0)
  801474:	85 c0                	test   %eax,%eax
  801476:	74 06                	je     80147e <readn+0x3b>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801478:	01 c3                	add    %eax,%ebx
  80147a:	39 f3                	cmp    %esi,%ebx
  80147c:	72 db                	jb     801459 <readn+0x16>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80147e:	89 d8                	mov    %ebx,%eax
}
  801480:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801483:	5b                   	pop    %ebx
  801484:	5e                   	pop    %esi
  801485:	5f                   	pop    %edi
  801486:	5d                   	pop    %ebp
  801487:	c3                   	ret    

00801488 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
  80148b:	53                   	push   %ebx
  80148c:	83 ec 14             	sub    $0x14,%esp
  80148f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801492:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801495:	50                   	push   %eax
  801496:	53                   	push   %ebx
  801497:	e8 ac fc ff ff       	call   801148 <fd_lookup>
  80149c:	83 c4 08             	add    $0x8,%esp
  80149f:	89 c2                	mov    %eax,%edx
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	78 68                	js     80150d <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a5:	83 ec 08             	sub    $0x8,%esp
  8014a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ab:	50                   	push   %eax
  8014ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014af:	ff 30                	pushl  (%eax)
  8014b1:	e8 e8 fc ff ff       	call   80119e <dev_lookup>
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	78 47                	js     801504 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014c4:	75 21                	jne    8014e7 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014c6:	a1 40 44 80 00       	mov    0x804440,%eax
  8014cb:	8b 40 48             	mov    0x48(%eax),%eax
  8014ce:	83 ec 04             	sub    $0x4,%esp
  8014d1:	53                   	push   %ebx
  8014d2:	50                   	push   %eax
  8014d3:	68 6c 27 80 00       	push   $0x80276c
  8014d8:	e8 20 ef ff ff       	call   8003fd <cprintf>
		return -E_INVAL;
  8014dd:	83 c4 10             	add    $0x10,%esp
  8014e0:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8014e5:	eb 26                	jmp    80150d <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ea:	8b 52 0c             	mov    0xc(%edx),%edx
  8014ed:	85 d2                	test   %edx,%edx
  8014ef:	74 17                	je     801508 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014f1:	83 ec 04             	sub    $0x4,%esp
  8014f4:	ff 75 10             	pushl  0x10(%ebp)
  8014f7:	ff 75 0c             	pushl  0xc(%ebp)
  8014fa:	50                   	push   %eax
  8014fb:	ff d2                	call   *%edx
  8014fd:	89 c2                	mov    %eax,%edx
  8014ff:	83 c4 10             	add    $0x10,%esp
  801502:	eb 09                	jmp    80150d <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801504:	89 c2                	mov    %eax,%edx
  801506:	eb 05                	jmp    80150d <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801508:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  80150d:	89 d0                	mov    %edx,%eax
  80150f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <seek>:

int
seek(int fdnum, off_t offset)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80151a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80151d:	50                   	push   %eax
  80151e:	ff 75 08             	pushl  0x8(%ebp)
  801521:	e8 22 fc ff ff       	call   801148 <fd_lookup>
  801526:	83 c4 08             	add    $0x8,%esp
  801529:	85 c0                	test   %eax,%eax
  80152b:	78 0e                	js     80153b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80152d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801530:	8b 55 0c             	mov    0xc(%ebp),%edx
  801533:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801536:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

0080153d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
  801540:	53                   	push   %ebx
  801541:	83 ec 14             	sub    $0x14,%esp
  801544:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801547:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80154a:	50                   	push   %eax
  80154b:	53                   	push   %ebx
  80154c:	e8 f7 fb ff ff       	call   801148 <fd_lookup>
  801551:	83 c4 08             	add    $0x8,%esp
  801554:	89 c2                	mov    %eax,%edx
  801556:	85 c0                	test   %eax,%eax
  801558:	78 65                	js     8015bf <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80155a:	83 ec 08             	sub    $0x8,%esp
  80155d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801560:	50                   	push   %eax
  801561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801564:	ff 30                	pushl  (%eax)
  801566:	e8 33 fc ff ff       	call   80119e <dev_lookup>
  80156b:	83 c4 10             	add    $0x10,%esp
  80156e:	85 c0                	test   %eax,%eax
  801570:	78 44                	js     8015b6 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801575:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801579:	75 21                	jne    80159c <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80157b:	a1 40 44 80 00       	mov    0x804440,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801580:	8b 40 48             	mov    0x48(%eax),%eax
  801583:	83 ec 04             	sub    $0x4,%esp
  801586:	53                   	push   %ebx
  801587:	50                   	push   %eax
  801588:	68 2c 27 80 00       	push   $0x80272c
  80158d:	e8 6b ee ff ff       	call   8003fd <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801592:	83 c4 10             	add    $0x10,%esp
  801595:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80159a:	eb 23                	jmp    8015bf <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  80159c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80159f:	8b 52 18             	mov    0x18(%edx),%edx
  8015a2:	85 d2                	test   %edx,%edx
  8015a4:	74 14                	je     8015ba <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015a6:	83 ec 08             	sub    $0x8,%esp
  8015a9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ac:	50                   	push   %eax
  8015ad:	ff d2                	call   *%edx
  8015af:	89 c2                	mov    %eax,%edx
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	eb 09                	jmp    8015bf <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b6:	89 c2                	mov    %eax,%edx
  8015b8:	eb 05                	jmp    8015bf <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8015ba:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  8015bf:	89 d0                	mov    %edx,%eax
  8015c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	53                   	push   %ebx
  8015ca:	83 ec 14             	sub    $0x14,%esp
  8015cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d3:	50                   	push   %eax
  8015d4:	ff 75 08             	pushl  0x8(%ebp)
  8015d7:	e8 6c fb ff ff       	call   801148 <fd_lookup>
  8015dc:	83 c4 08             	add    $0x8,%esp
  8015df:	89 c2                	mov    %eax,%edx
  8015e1:	85 c0                	test   %eax,%eax
  8015e3:	78 58                	js     80163d <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e5:	83 ec 08             	sub    $0x8,%esp
  8015e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015eb:	50                   	push   %eax
  8015ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ef:	ff 30                	pushl  (%eax)
  8015f1:	e8 a8 fb ff ff       	call   80119e <dev_lookup>
  8015f6:	83 c4 10             	add    $0x10,%esp
  8015f9:	85 c0                	test   %eax,%eax
  8015fb:	78 37                	js     801634 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8015fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801600:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801604:	74 32                	je     801638 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801606:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801609:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801610:	00 00 00 
	stat->st_isdir = 0;
  801613:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80161a:	00 00 00 
	stat->st_dev = dev;
  80161d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801623:	83 ec 08             	sub    $0x8,%esp
  801626:	53                   	push   %ebx
  801627:	ff 75 f0             	pushl  -0x10(%ebp)
  80162a:	ff 50 14             	call   *0x14(%eax)
  80162d:	89 c2                	mov    %eax,%edx
  80162f:	83 c4 10             	add    $0x10,%esp
  801632:	eb 09                	jmp    80163d <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801634:	89 c2                	mov    %eax,%edx
  801636:	eb 05                	jmp    80163d <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801638:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80163d:	89 d0                	mov    %edx,%eax
  80163f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	56                   	push   %esi
  801648:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801649:	83 ec 08             	sub    $0x8,%esp
  80164c:	6a 00                	push   $0x0
  80164e:	ff 75 08             	pushl  0x8(%ebp)
  801651:	e8 09 02 00 00       	call   80185f <open>
  801656:	89 c3                	mov    %eax,%ebx
  801658:	83 c4 10             	add    $0x10,%esp
  80165b:	85 db                	test   %ebx,%ebx
  80165d:	78 1b                	js     80167a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80165f:	83 ec 08             	sub    $0x8,%esp
  801662:	ff 75 0c             	pushl  0xc(%ebp)
  801665:	53                   	push   %ebx
  801666:	e8 5b ff ff ff       	call   8015c6 <fstat>
  80166b:	89 c6                	mov    %eax,%esi
	close(fd);
  80166d:	89 1c 24             	mov    %ebx,(%esp)
  801670:	e8 fd fb ff ff       	call   801272 <close>
	return r;
  801675:	83 c4 10             	add    $0x10,%esp
  801678:	89 f0                	mov    %esi,%eax
}
  80167a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80167d:	5b                   	pop    %ebx
  80167e:	5e                   	pop    %esi
  80167f:	5d                   	pop    %ebp
  801680:	c3                   	ret    

00801681 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	56                   	push   %esi
  801685:	53                   	push   %ebx
  801686:	89 c6                	mov    %eax,%esi
  801688:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80168a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801691:	75 12                	jne    8016a5 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801693:	83 ec 0c             	sub    $0xc,%esp
  801696:	6a 01                	push   $0x1
  801698:	e8 0f 09 00 00       	call   801fac <ipc_find_env>
  80169d:	a3 00 40 80 00       	mov    %eax,0x804000
  8016a2:	83 c4 10             	add    $0x10,%esp
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016a5:	6a 07                	push   $0x7
  8016a7:	68 00 50 80 00       	push   $0x805000
  8016ac:	56                   	push   %esi
  8016ad:	ff 35 00 40 80 00    	pushl  0x804000
  8016b3:	e8 a0 08 00 00       	call   801f58 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016b8:	83 c4 0c             	add    $0xc,%esp
  8016bb:	6a 00                	push   $0x0
  8016bd:	53                   	push   %ebx
  8016be:	6a 00                	push   $0x0
  8016c0:	e8 2a 08 00 00       	call   801eef <ipc_recv>
}
  8016c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c8:	5b                   	pop    %ebx
  8016c9:	5e                   	pop    %esi
  8016ca:	5d                   	pop    %ebp
  8016cb:	c3                   	ret    

008016cc <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e0:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ea:	b8 02 00 00 00       	mov    $0x2,%eax
  8016ef:	e8 8d ff ff ff       	call   801681 <fsipc>
}
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	8b 40 0c             	mov    0xc(%eax),%eax
  801702:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801707:	ba 00 00 00 00       	mov    $0x0,%edx
  80170c:	b8 06 00 00 00       	mov    $0x6,%eax
  801711:	e8 6b ff ff ff       	call   801681 <fsipc>
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <devfile_stat>:
        return src_buf - buf;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	53                   	push   %ebx
  80171c:	83 ec 04             	sub    $0x4,%esp
  80171f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	8b 40 0c             	mov    0xc(%eax),%eax
  801728:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80172d:	ba 00 00 00 00       	mov    $0x0,%edx
  801732:	b8 05 00 00 00       	mov    $0x5,%eax
  801737:	e8 45 ff ff ff       	call   801681 <fsipc>
  80173c:	89 c2                	mov    %eax,%edx
  80173e:	85 d2                	test   %edx,%edx
  801740:	78 2c                	js     80176e <devfile_stat+0x56>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801742:	83 ec 08             	sub    $0x8,%esp
  801745:	68 00 50 80 00       	push   $0x805000
  80174a:	53                   	push   %ebx
  80174b:	e8 34 f2 ff ff       	call   800984 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801750:	a1 80 50 80 00       	mov    0x805080,%eax
  801755:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80175b:	a1 84 50 80 00       	mov    0x805084,%eax
  801760:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801766:	83 c4 10             	add    $0x10,%esp
  801769:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80176e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	57                   	push   %edi
  801777:	56                   	push   %esi
  801778:	53                   	push   %ebx
  801779:	83 ec 0c             	sub    $0xc,%esp
  80177c:	8b 75 10             	mov    0x10(%ebp),%esi
	//panic("devfile_write not implemented");
        int r;
        const void *src_buf = buf;
        size_t ipc_buf_size = PGSIZE - (sizeof(int) + sizeof(size_t));
 
        fsipcbuf.write.req_fileid = fd->fd_file.id;       
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	8b 40 0c             	mov    0xc(%eax),%eax
  801785:	a3 00 50 80 00       	mov    %eax,0x805000
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
        int r;
        const void *src_buf = buf;
  80178a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
        size_t ipc_buf_size = PGSIZE - (sizeof(int) + sizeof(size_t));
 
        fsipcbuf.write.req_fileid = fd->fd_file.id;       
        while( n > 0) {
  80178d:	eb 3d                	jmp    8017cc <devfile_write+0x59>
                size_t tmp = MIN(ipc_buf_size, n);
  80178f:	81 fe f8 0f 00 00    	cmp    $0xff8,%esi
  801795:	bf f8 0f 00 00       	mov    $0xff8,%edi
  80179a:	0f 46 fe             	cmovbe %esi,%edi
                memmove(fsipcbuf.write.req_buf, src_buf, tmp);
  80179d:	83 ec 04             	sub    $0x4,%esp
  8017a0:	57                   	push   %edi
  8017a1:	53                   	push   %ebx
  8017a2:	68 08 50 80 00       	push   $0x805008
  8017a7:	e8 6a f3 ff ff       	call   800b16 <memmove>
                fsipcbuf.write.req_n = tmp; 
  8017ac:	89 3d 04 50 80 00    	mov    %edi,0x805004
                if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b7:	b8 04 00 00 00       	mov    $0x4,%eax
  8017bc:	e8 c0 fe ff ff       	call   801681 <fsipc>
  8017c1:	83 c4 10             	add    $0x10,%esp
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	78 0d                	js     8017d5 <devfile_write+0x62>
		        return r;
                n -= tmp;
  8017c8:	29 fe                	sub    %edi,%esi
                src_buf += tmp;
  8017ca:	01 fb                	add    %edi,%ebx
        int r;
        const void *src_buf = buf;
        size_t ipc_buf_size = PGSIZE - (sizeof(int) + sizeof(size_t));
 
        fsipcbuf.write.req_fileid = fd->fd_file.id;       
        while( n > 0) {
  8017cc:	85 f6                	test   %esi,%esi
  8017ce:	75 bf                	jne    80178f <devfile_write+0x1c>
                if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
		        return r;
                n -= tmp;
                src_buf += tmp;
        } 
        return src_buf - buf;
  8017d0:	89 d8                	mov    %ebx,%eax
  8017d2:	2b 45 0c             	sub    0xc(%ebp),%eax
}
  8017d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017d8:	5b                   	pop    %ebx
  8017d9:	5e                   	pop    %esi
  8017da:	5f                   	pop    %edi
  8017db:	5d                   	pop    %ebp
  8017dc:	c3                   	ret    

008017dd <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	56                   	push   %esi
  8017e1:	53                   	push   %ebx
  8017e2:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8017eb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017f0:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fb:	b8 03 00 00 00       	mov    $0x3,%eax
  801800:	e8 7c fe ff ff       	call   801681 <fsipc>
  801805:	89 c3                	mov    %eax,%ebx
  801807:	85 c0                	test   %eax,%eax
  801809:	78 4b                	js     801856 <devfile_read+0x79>
		return r;
	assert(r <= n);
  80180b:	39 c6                	cmp    %eax,%esi
  80180d:	73 16                	jae    801825 <devfile_read+0x48>
  80180f:	68 9c 27 80 00       	push   $0x80279c
  801814:	68 a3 27 80 00       	push   $0x8027a3
  801819:	6a 7c                	push   $0x7c
  80181b:	68 b8 27 80 00       	push   $0x8027b8
  801820:	e8 ff ea ff ff       	call   800324 <_panic>
	assert(r <= PGSIZE);
  801825:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80182a:	7e 16                	jle    801842 <devfile_read+0x65>
  80182c:	68 c3 27 80 00       	push   $0x8027c3
  801831:	68 a3 27 80 00       	push   $0x8027a3
  801836:	6a 7d                	push   $0x7d
  801838:	68 b8 27 80 00       	push   $0x8027b8
  80183d:	e8 e2 ea ff ff       	call   800324 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801842:	83 ec 04             	sub    $0x4,%esp
  801845:	50                   	push   %eax
  801846:	68 00 50 80 00       	push   $0x805000
  80184b:	ff 75 0c             	pushl  0xc(%ebp)
  80184e:	e8 c3 f2 ff ff       	call   800b16 <memmove>
	return r;
  801853:	83 c4 10             	add    $0x10,%esp
}
  801856:	89 d8                	mov    %ebx,%eax
  801858:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80185b:	5b                   	pop    %ebx
  80185c:	5e                   	pop    %esi
  80185d:	5d                   	pop    %ebp
  80185e:	c3                   	ret    

0080185f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	53                   	push   %ebx
  801863:	83 ec 20             	sub    $0x20,%esp
  801866:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801869:	53                   	push   %ebx
  80186a:	e8 dc f0 ff ff       	call   80094b <strlen>
  80186f:	83 c4 10             	add    $0x10,%esp
  801872:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801877:	7f 67                	jg     8018e0 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801879:	83 ec 0c             	sub    $0xc,%esp
  80187c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80187f:	50                   	push   %eax
  801880:	e8 74 f8 ff ff       	call   8010f9 <fd_alloc>
  801885:	83 c4 10             	add    $0x10,%esp
		return r;
  801888:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80188a:	85 c0                	test   %eax,%eax
  80188c:	78 57                	js     8018e5 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80188e:	83 ec 08             	sub    $0x8,%esp
  801891:	53                   	push   %ebx
  801892:	68 00 50 80 00       	push   $0x805000
  801897:	e8 e8 f0 ff ff       	call   800984 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80189c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189f:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ac:	e8 d0 fd ff ff       	call   801681 <fsipc>
  8018b1:	89 c3                	mov    %eax,%ebx
  8018b3:	83 c4 10             	add    $0x10,%esp
  8018b6:	85 c0                	test   %eax,%eax
  8018b8:	79 14                	jns    8018ce <open+0x6f>
		fd_close(fd, 0);
  8018ba:	83 ec 08             	sub    $0x8,%esp
  8018bd:	6a 00                	push   $0x0
  8018bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c2:	e8 2a f9 ff ff       	call   8011f1 <fd_close>
		return r;
  8018c7:	83 c4 10             	add    $0x10,%esp
  8018ca:	89 da                	mov    %ebx,%edx
  8018cc:	eb 17                	jmp    8018e5 <open+0x86>
	}

	return fd2num(fd);
  8018ce:	83 ec 0c             	sub    $0xc,%esp
  8018d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d4:	e8 f9 f7 ff ff       	call   8010d2 <fd2num>
  8018d9:	89 c2                	mov    %eax,%edx
  8018db:	83 c4 10             	add    $0x10,%esp
  8018de:	eb 05                	jmp    8018e5 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8018e0:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8018e5:	89 d0                	mov    %edx,%eax
  8018e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f7:	b8 08 00 00 00       	mov    $0x8,%eax
  8018fc:	e8 80 fd ff ff       	call   801681 <fsipc>
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801903:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801907:	7e 37                	jle    801940 <writebuf+0x3d>
};


static void
writebuf(struct printbuf *b)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	53                   	push   %ebx
  80190d:	83 ec 08             	sub    $0x8,%esp
  801910:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
		ssize_t result = write(b->fd, b->buf, b->idx);
  801912:	ff 70 04             	pushl  0x4(%eax)
  801915:	8d 40 10             	lea    0x10(%eax),%eax
  801918:	50                   	push   %eax
  801919:	ff 33                	pushl  (%ebx)
  80191b:	e8 68 fb ff ff       	call   801488 <write>
		if (result > 0)
  801920:	83 c4 10             	add    $0x10,%esp
  801923:	85 c0                	test   %eax,%eax
  801925:	7e 03                	jle    80192a <writebuf+0x27>
			b->result += result;
  801927:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80192a:	39 43 04             	cmp    %eax,0x4(%ebx)
  80192d:	74 0d                	je     80193c <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  80192f:	85 c0                	test   %eax,%eax
  801931:	ba 00 00 00 00       	mov    $0x0,%edx
  801936:	0f 4f c2             	cmovg  %edx,%eax
  801939:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80193c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80193f:	c9                   	leave  
  801940:	f3 c3                	repz ret 

00801942 <putch>:

static void
putch(int ch, void *thunk)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	53                   	push   %ebx
  801946:	83 ec 04             	sub    $0x4,%esp
  801949:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80194c:	8b 53 04             	mov    0x4(%ebx),%edx
  80194f:	8d 42 01             	lea    0x1(%edx),%eax
  801952:	89 43 04             	mov    %eax,0x4(%ebx)
  801955:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801958:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80195c:	3d 00 01 00 00       	cmp    $0x100,%eax
  801961:	75 0e                	jne    801971 <putch+0x2f>
		writebuf(b);
  801963:	89 d8                	mov    %ebx,%eax
  801965:	e8 99 ff ff ff       	call   801903 <writebuf>
		b->idx = 0;
  80196a:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801971:	83 c4 04             	add    $0x4,%esp
  801974:	5b                   	pop    %ebx
  801975:	5d                   	pop    %ebp
  801976:	c3                   	ret    

00801977 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801989:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801990:	00 00 00 
	b.result = 0;
  801993:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80199a:	00 00 00 
	b.error = 1;
  80199d:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8019a4:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8019a7:	ff 75 10             	pushl  0x10(%ebp)
  8019aa:	ff 75 0c             	pushl  0xc(%ebp)
  8019ad:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8019b3:	50                   	push   %eax
  8019b4:	68 42 19 80 00       	push   $0x801942
  8019b9:	e8 71 eb ff ff       	call   80052f <vprintfmt>
	if (b.idx > 0)
  8019be:	83 c4 10             	add    $0x10,%esp
  8019c1:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8019c8:	7e 0b                	jle    8019d5 <vfprintf+0x5e>
		writebuf(&b);
  8019ca:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8019d0:	e8 2e ff ff ff       	call   801903 <writebuf>

	return (b.result ? b.result : b.error);
  8019d5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8019db:	85 c0                	test   %eax,%eax
  8019dd:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019ec:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8019ef:	50                   	push   %eax
  8019f0:	ff 75 0c             	pushl  0xc(%ebp)
  8019f3:	ff 75 08             	pushl  0x8(%ebp)
  8019f6:	e8 7c ff ff ff       	call   801977 <vfprintf>
	va_end(ap);

	return cnt;
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <printf>:

int
printf(const char *fmt, ...)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a03:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a06:	50                   	push   %eax
  801a07:	ff 75 08             	pushl  0x8(%ebp)
  801a0a:	6a 01                	push   $0x1
  801a0c:	e8 66 ff ff ff       	call   801977 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	56                   	push   %esi
  801a17:	53                   	push   %ebx
  801a18:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a1b:	83 ec 0c             	sub    $0xc,%esp
  801a1e:	ff 75 08             	pushl  0x8(%ebp)
  801a21:	e8 bc f6 ff ff       	call   8010e2 <fd2data>
  801a26:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a28:	83 c4 08             	add    $0x8,%esp
  801a2b:	68 cf 27 80 00       	push   $0x8027cf
  801a30:	53                   	push   %ebx
  801a31:	e8 4e ef ff ff       	call   800984 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a36:	8b 56 04             	mov    0x4(%esi),%edx
  801a39:	89 d0                	mov    %edx,%eax
  801a3b:	2b 06                	sub    (%esi),%eax
  801a3d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a43:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a4a:	00 00 00 
	stat->st_dev = &devpipe;
  801a4d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a54:	30 80 00 
	return 0;
}
  801a57:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a5f:	5b                   	pop    %ebx
  801a60:	5e                   	pop    %esi
  801a61:	5d                   	pop    %ebp
  801a62:	c3                   	ret    

00801a63 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	53                   	push   %ebx
  801a67:	83 ec 0c             	sub    $0xc,%esp
  801a6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a6d:	53                   	push   %ebx
  801a6e:	6a 00                	push   $0x0
  801a70:	e8 9d f3 ff ff       	call   800e12 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a75:	89 1c 24             	mov    %ebx,(%esp)
  801a78:	e8 65 f6 ff ff       	call   8010e2 <fd2data>
  801a7d:	83 c4 08             	add    $0x8,%esp
  801a80:	50                   	push   %eax
  801a81:	6a 00                	push   $0x0
  801a83:	e8 8a f3 ff ff       	call   800e12 <sys_page_unmap>
}
  801a88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	57                   	push   %edi
  801a91:	56                   	push   %esi
  801a92:	53                   	push   %ebx
  801a93:	83 ec 1c             	sub    $0x1c,%esp
  801a96:	89 c6                	mov    %eax,%esi
  801a98:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801a9b:	a1 40 44 80 00       	mov    0x804440,%eax
  801aa0:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801aa3:	83 ec 0c             	sub    $0xc,%esp
  801aa6:	56                   	push   %esi
  801aa7:	e8 38 05 00 00       	call   801fe4 <pageref>
  801aac:	89 c7                	mov    %eax,%edi
  801aae:	83 c4 04             	add    $0x4,%esp
  801ab1:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ab4:	e8 2b 05 00 00       	call   801fe4 <pageref>
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	39 c7                	cmp    %eax,%edi
  801abe:	0f 94 c2             	sete   %dl
  801ac1:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801ac4:	8b 0d 40 44 80 00    	mov    0x804440,%ecx
  801aca:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801acd:	39 fb                	cmp    %edi,%ebx
  801acf:	74 19                	je     801aea <_pipeisclosed+0x5d>
			return ret;
		if (n != nn && ret == 1)
  801ad1:	84 d2                	test   %dl,%dl
  801ad3:	74 c6                	je     801a9b <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ad5:	8b 51 58             	mov    0x58(%ecx),%edx
  801ad8:	50                   	push   %eax
  801ad9:	52                   	push   %edx
  801ada:	53                   	push   %ebx
  801adb:	68 d6 27 80 00       	push   $0x8027d6
  801ae0:	e8 18 e9 ff ff       	call   8003fd <cprintf>
  801ae5:	83 c4 10             	add    $0x10,%esp
  801ae8:	eb b1                	jmp    801a9b <_pipeisclosed+0xe>
	}
}
  801aea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aed:	5b                   	pop    %ebx
  801aee:	5e                   	pop    %esi
  801aef:	5f                   	pop    %edi
  801af0:	5d                   	pop    %ebp
  801af1:	c3                   	ret    

00801af2 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	57                   	push   %edi
  801af6:	56                   	push   %esi
  801af7:	53                   	push   %ebx
  801af8:	83 ec 28             	sub    $0x28,%esp
  801afb:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801afe:	56                   	push   %esi
  801aff:	e8 de f5 ff ff       	call   8010e2 <fd2data>
  801b04:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b06:	83 c4 10             	add    $0x10,%esp
  801b09:	bf 00 00 00 00       	mov    $0x0,%edi
  801b0e:	eb 4b                	jmp    801b5b <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801b10:	89 da                	mov    %ebx,%edx
  801b12:	89 f0                	mov    %esi,%eax
  801b14:	e8 74 ff ff ff       	call   801a8d <_pipeisclosed>
  801b19:	85 c0                	test   %eax,%eax
  801b1b:	75 48                	jne    801b65 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801b1d:	e8 4c f2 ff ff       	call   800d6e <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b22:	8b 43 04             	mov    0x4(%ebx),%eax
  801b25:	8b 0b                	mov    (%ebx),%ecx
  801b27:	8d 51 20             	lea    0x20(%ecx),%edx
  801b2a:	39 d0                	cmp    %edx,%eax
  801b2c:	73 e2                	jae    801b10 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b31:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b35:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b38:	89 c2                	mov    %eax,%edx
  801b3a:	c1 fa 1f             	sar    $0x1f,%edx
  801b3d:	89 d1                	mov    %edx,%ecx
  801b3f:	c1 e9 1b             	shr    $0x1b,%ecx
  801b42:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b45:	83 e2 1f             	and    $0x1f,%edx
  801b48:	29 ca                	sub    %ecx,%edx
  801b4a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b4e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b52:	83 c0 01             	add    $0x1,%eax
  801b55:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b58:	83 c7 01             	add    $0x1,%edi
  801b5b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b5e:	75 c2                	jne    801b22 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801b60:	8b 45 10             	mov    0x10(%ebp),%eax
  801b63:	eb 05                	jmp    801b6a <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801b65:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801b6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b6d:	5b                   	pop    %ebx
  801b6e:	5e                   	pop    %esi
  801b6f:	5f                   	pop    %edi
  801b70:	5d                   	pop    %ebp
  801b71:	c3                   	ret    

00801b72 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	57                   	push   %edi
  801b76:	56                   	push   %esi
  801b77:	53                   	push   %ebx
  801b78:	83 ec 18             	sub    $0x18,%esp
  801b7b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801b7e:	57                   	push   %edi
  801b7f:	e8 5e f5 ff ff       	call   8010e2 <fd2data>
  801b84:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b86:	83 c4 10             	add    $0x10,%esp
  801b89:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b8e:	eb 3d                	jmp    801bcd <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801b90:	85 db                	test   %ebx,%ebx
  801b92:	74 04                	je     801b98 <devpipe_read+0x26>
				return i;
  801b94:	89 d8                	mov    %ebx,%eax
  801b96:	eb 44                	jmp    801bdc <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801b98:	89 f2                	mov    %esi,%edx
  801b9a:	89 f8                	mov    %edi,%eax
  801b9c:	e8 ec fe ff ff       	call   801a8d <_pipeisclosed>
  801ba1:	85 c0                	test   %eax,%eax
  801ba3:	75 32                	jne    801bd7 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801ba5:	e8 c4 f1 ff ff       	call   800d6e <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801baa:	8b 06                	mov    (%esi),%eax
  801bac:	3b 46 04             	cmp    0x4(%esi),%eax
  801baf:	74 df                	je     801b90 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801bb1:	99                   	cltd   
  801bb2:	c1 ea 1b             	shr    $0x1b,%edx
  801bb5:	01 d0                	add    %edx,%eax
  801bb7:	83 e0 1f             	and    $0x1f,%eax
  801bba:	29 d0                	sub    %edx,%eax
  801bbc:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801bc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bc4:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801bc7:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801bca:	83 c3 01             	add    $0x1,%ebx
  801bcd:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801bd0:	75 d8                	jne    801baa <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801bd2:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd5:	eb 05                	jmp    801bdc <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801bd7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801bdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bdf:	5b                   	pop    %ebx
  801be0:	5e                   	pop    %esi
  801be1:	5f                   	pop    %edi
  801be2:	5d                   	pop    %ebp
  801be3:	c3                   	ret    

00801be4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	56                   	push   %esi
  801be8:	53                   	push   %ebx
  801be9:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801bec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bef:	50                   	push   %eax
  801bf0:	e8 04 f5 ff ff       	call   8010f9 <fd_alloc>
  801bf5:	83 c4 10             	add    $0x10,%esp
  801bf8:	89 c2                	mov    %eax,%edx
  801bfa:	85 c0                	test   %eax,%eax
  801bfc:	0f 88 2c 01 00 00    	js     801d2e <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c02:	83 ec 04             	sub    $0x4,%esp
  801c05:	68 07 04 00 00       	push   $0x407
  801c0a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c0d:	6a 00                	push   $0x0
  801c0f:	e8 79 f1 ff ff       	call   800d8d <sys_page_alloc>
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	89 c2                	mov    %eax,%edx
  801c19:	85 c0                	test   %eax,%eax
  801c1b:	0f 88 0d 01 00 00    	js     801d2e <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801c21:	83 ec 0c             	sub    $0xc,%esp
  801c24:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c27:	50                   	push   %eax
  801c28:	e8 cc f4 ff ff       	call   8010f9 <fd_alloc>
  801c2d:	89 c3                	mov    %eax,%ebx
  801c2f:	83 c4 10             	add    $0x10,%esp
  801c32:	85 c0                	test   %eax,%eax
  801c34:	0f 88 e2 00 00 00    	js     801d1c <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c3a:	83 ec 04             	sub    $0x4,%esp
  801c3d:	68 07 04 00 00       	push   $0x407
  801c42:	ff 75 f0             	pushl  -0x10(%ebp)
  801c45:	6a 00                	push   $0x0
  801c47:	e8 41 f1 ff ff       	call   800d8d <sys_page_alloc>
  801c4c:	89 c3                	mov    %eax,%ebx
  801c4e:	83 c4 10             	add    $0x10,%esp
  801c51:	85 c0                	test   %eax,%eax
  801c53:	0f 88 c3 00 00 00    	js     801d1c <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801c59:	83 ec 0c             	sub    $0xc,%esp
  801c5c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c5f:	e8 7e f4 ff ff       	call   8010e2 <fd2data>
  801c64:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c66:	83 c4 0c             	add    $0xc,%esp
  801c69:	68 07 04 00 00       	push   $0x407
  801c6e:	50                   	push   %eax
  801c6f:	6a 00                	push   $0x0
  801c71:	e8 17 f1 ff ff       	call   800d8d <sys_page_alloc>
  801c76:	89 c3                	mov    %eax,%ebx
  801c78:	83 c4 10             	add    $0x10,%esp
  801c7b:	85 c0                	test   %eax,%eax
  801c7d:	0f 88 89 00 00 00    	js     801d0c <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c83:	83 ec 0c             	sub    $0xc,%esp
  801c86:	ff 75 f0             	pushl  -0x10(%ebp)
  801c89:	e8 54 f4 ff ff       	call   8010e2 <fd2data>
  801c8e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c95:	50                   	push   %eax
  801c96:	6a 00                	push   $0x0
  801c98:	56                   	push   %esi
  801c99:	6a 00                	push   $0x0
  801c9b:	e8 30 f1 ff ff       	call   800dd0 <sys_page_map>
  801ca0:	89 c3                	mov    %eax,%ebx
  801ca2:	83 c4 20             	add    $0x20,%esp
  801ca5:	85 c0                	test   %eax,%eax
  801ca7:	78 55                	js     801cfe <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801ca9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801cbe:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ccc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801cd3:	83 ec 0c             	sub    $0xc,%esp
  801cd6:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd9:	e8 f4 f3 ff ff       	call   8010d2 <fd2num>
  801cde:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ce1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ce3:	83 c4 04             	add    $0x4,%esp
  801ce6:	ff 75 f0             	pushl  -0x10(%ebp)
  801ce9:	e8 e4 f3 ff ff       	call   8010d2 <fd2num>
  801cee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801cf4:	83 c4 10             	add    $0x10,%esp
  801cf7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cfc:	eb 30                	jmp    801d2e <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801cfe:	83 ec 08             	sub    $0x8,%esp
  801d01:	56                   	push   %esi
  801d02:	6a 00                	push   $0x0
  801d04:	e8 09 f1 ff ff       	call   800e12 <sys_page_unmap>
  801d09:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801d0c:	83 ec 08             	sub    $0x8,%esp
  801d0f:	ff 75 f0             	pushl  -0x10(%ebp)
  801d12:	6a 00                	push   $0x0
  801d14:	e8 f9 f0 ff ff       	call   800e12 <sys_page_unmap>
  801d19:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801d1c:	83 ec 08             	sub    $0x8,%esp
  801d1f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d22:	6a 00                	push   $0x0
  801d24:	e8 e9 f0 ff ff       	call   800e12 <sys_page_unmap>
  801d29:	83 c4 10             	add    $0x10,%esp
  801d2c:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801d2e:	89 d0                	mov    %edx,%eax
  801d30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d33:	5b                   	pop    %ebx
  801d34:	5e                   	pop    %esi
  801d35:	5d                   	pop    %ebp
  801d36:	c3                   	ret    

00801d37 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d3d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d40:	50                   	push   %eax
  801d41:	ff 75 08             	pushl  0x8(%ebp)
  801d44:	e8 ff f3 ff ff       	call   801148 <fd_lookup>
  801d49:	89 c2                	mov    %eax,%edx
  801d4b:	83 c4 10             	add    $0x10,%esp
  801d4e:	85 d2                	test   %edx,%edx
  801d50:	78 18                	js     801d6a <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801d52:	83 ec 0c             	sub    $0xc,%esp
  801d55:	ff 75 f4             	pushl  -0xc(%ebp)
  801d58:	e8 85 f3 ff ff       	call   8010e2 <fd2data>
	return _pipeisclosed(fd, p);
  801d5d:	89 c2                	mov    %eax,%edx
  801d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d62:	e8 26 fd ff ff       	call   801a8d <_pipeisclosed>
  801d67:	83 c4 10             	add    $0x10,%esp
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d74:	5d                   	pop    %ebp
  801d75:	c3                   	ret    

00801d76 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d7c:	68 ee 27 80 00       	push   $0x8027ee
  801d81:	ff 75 0c             	pushl  0xc(%ebp)
  801d84:	e8 fb eb ff ff       	call   800984 <strcpy>
	return 0;
}
  801d89:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	57                   	push   %edi
  801d94:	56                   	push   %esi
  801d95:	53                   	push   %ebx
  801d96:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d9c:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801da1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801da7:	eb 2d                	jmp    801dd6 <devcons_write+0x46>
		m = n - tot;
  801da9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801dac:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801dae:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801db1:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801db6:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801db9:	83 ec 04             	sub    $0x4,%esp
  801dbc:	53                   	push   %ebx
  801dbd:	03 45 0c             	add    0xc(%ebp),%eax
  801dc0:	50                   	push   %eax
  801dc1:	57                   	push   %edi
  801dc2:	e8 4f ed ff ff       	call   800b16 <memmove>
		sys_cputs(buf, m);
  801dc7:	83 c4 08             	add    $0x8,%esp
  801dca:	53                   	push   %ebx
  801dcb:	57                   	push   %edi
  801dcc:	e8 00 ef ff ff       	call   800cd1 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801dd1:	01 de                	add    %ebx,%esi
  801dd3:	83 c4 10             	add    $0x10,%esp
  801dd6:	89 f0                	mov    %esi,%eax
  801dd8:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ddb:	72 cc                	jb     801da9 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801de0:	5b                   	pop    %ebx
  801de1:	5e                   	pop    %esi
  801de2:	5f                   	pop    %edi
  801de3:	5d                   	pop    %ebp
  801de4:	c3                   	ret    

00801de5 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801deb:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801df4:	75 07                	jne    801dfd <devcons_read+0x18>
  801df6:	eb 28                	jmp    801e20 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801df8:	e8 71 ef ff ff       	call   800d6e <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801dfd:	e8 ed ee ff ff       	call   800cef <sys_cgetc>
  801e02:	85 c0                	test   %eax,%eax
  801e04:	74 f2                	je     801df8 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801e06:	85 c0                	test   %eax,%eax
  801e08:	78 16                	js     801e20 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801e0a:	83 f8 04             	cmp    $0x4,%eax
  801e0d:	74 0c                	je     801e1b <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801e0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e12:	88 02                	mov    %al,(%edx)
	return 1;
  801e14:	b8 01 00 00 00       	mov    $0x1,%eax
  801e19:	eb 05                	jmp    801e20 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e28:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801e2e:	6a 01                	push   $0x1
  801e30:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e33:	50                   	push   %eax
  801e34:	e8 98 ee ff ff       	call   800cd1 <sys_cputs>
  801e39:	83 c4 10             	add    $0x10,%esp
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <getchar>:

int
getchar(void)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801e44:	6a 01                	push   $0x1
  801e46:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e49:	50                   	push   %eax
  801e4a:	6a 00                	push   $0x0
  801e4c:	e8 61 f5 ff ff       	call   8013b2 <read>
	if (r < 0)
  801e51:	83 c4 10             	add    $0x10,%esp
  801e54:	85 c0                	test   %eax,%eax
  801e56:	78 0f                	js     801e67 <getchar+0x29>
		return r;
	if (r < 1)
  801e58:	85 c0                	test   %eax,%eax
  801e5a:	7e 06                	jle    801e62 <getchar+0x24>
		return -E_EOF;
	return c;
  801e5c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801e60:	eb 05                	jmp    801e67 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801e62:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e72:	50                   	push   %eax
  801e73:	ff 75 08             	pushl  0x8(%ebp)
  801e76:	e8 cd f2 ff ff       	call   801148 <fd_lookup>
  801e7b:	83 c4 10             	add    $0x10,%esp
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	78 11                	js     801e93 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e85:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e8b:	39 10                	cmp    %edx,(%eax)
  801e8d:	0f 94 c0             	sete   %al
  801e90:	0f b6 c0             	movzbl %al,%eax
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <opencons>:

int
opencons(void)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801e9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e9e:	50                   	push   %eax
  801e9f:	e8 55 f2 ff ff       	call   8010f9 <fd_alloc>
  801ea4:	83 c4 10             	add    $0x10,%esp
		return r;
  801ea7:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801ea9:	85 c0                	test   %eax,%eax
  801eab:	78 3e                	js     801eeb <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ead:	83 ec 04             	sub    $0x4,%esp
  801eb0:	68 07 04 00 00       	push   $0x407
  801eb5:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb8:	6a 00                	push   $0x0
  801eba:	e8 ce ee ff ff       	call   800d8d <sys_page_alloc>
  801ebf:	83 c4 10             	add    $0x10,%esp
		return r;
  801ec2:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ec4:	85 c0                	test   %eax,%eax
  801ec6:	78 23                	js     801eeb <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801ec8:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801edd:	83 ec 0c             	sub    $0xc,%esp
  801ee0:	50                   	push   %eax
  801ee1:	e8 ec f1 ff ff       	call   8010d2 <fd2num>
  801ee6:	89 c2                	mov    %eax,%edx
  801ee8:	83 c4 10             	add    $0x10,%esp
}
  801eeb:	89 d0                	mov    %edx,%eax
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	56                   	push   %esi
  801ef3:	53                   	push   %ebx
  801ef4:	8b 75 08             	mov    0x8(%ebp),%esi
  801ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
        if(!pg) pg = (void *)UTOP;
  801efd:	85 c0                	test   %eax,%eax
  801eff:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f04:	0f 44 c2             	cmove  %edx,%eax
        int r;
        if((r = sys_ipc_recv(pg)) < 0) {
  801f07:	83 ec 0c             	sub    $0xc,%esp
  801f0a:	50                   	push   %eax
  801f0b:	e8 2d f0 ff ff       	call   800f3d <sys_ipc_recv>
  801f10:	83 c4 10             	add    $0x10,%esp
  801f13:	85 c0                	test   %eax,%eax
  801f15:	79 16                	jns    801f2d <ipc_recv+0x3e>
                if(from_env_store) *from_env_store = 0;
  801f17:	85 f6                	test   %esi,%esi
  801f19:	74 06                	je     801f21 <ipc_recv+0x32>
  801f1b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
                if(perm_store) *perm_store = 0;
  801f21:	85 db                	test   %ebx,%ebx
  801f23:	74 2c                	je     801f51 <ipc_recv+0x62>
  801f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801f2b:	eb 24                	jmp    801f51 <ipc_recv+0x62>
                return r;
        }
        if(from_env_store) *from_env_store = thisenv->env_ipc_from;
  801f2d:	85 f6                	test   %esi,%esi
  801f2f:	74 0a                	je     801f3b <ipc_recv+0x4c>
  801f31:	a1 40 44 80 00       	mov    0x804440,%eax
  801f36:	8b 40 74             	mov    0x74(%eax),%eax
  801f39:	89 06                	mov    %eax,(%esi)
        if(perm_store) *perm_store = thisenv->env_ipc_perm;
  801f3b:	85 db                	test   %ebx,%ebx
  801f3d:	74 0a                	je     801f49 <ipc_recv+0x5a>
  801f3f:	a1 40 44 80 00       	mov    0x804440,%eax
  801f44:	8b 40 78             	mov    0x78(%eax),%eax
  801f47:	89 03                	mov    %eax,(%ebx)
         
	return thisenv->env_ipc_value;
  801f49:	a1 40 44 80 00       	mov    0x804440,%eax
  801f4e:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f54:	5b                   	pop    %ebx
  801f55:	5e                   	pop    %esi
  801f56:	5d                   	pop    %ebp
  801f57:	c3                   	ret    

00801f58 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	57                   	push   %edi
  801f5c:	56                   	push   %esi
  801f5d:	53                   	push   %ebx
  801f5e:	83 ec 0c             	sub    $0xc,%esp
  801f61:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f64:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f67:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
        if(!pg) pg = (void *)UTOP;
  801f6a:	85 db                	test   %ebx,%ebx
  801f6c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801f71:	0f 44 d8             	cmove  %eax,%ebx
  801f74:	eb 1c                	jmp    801f92 <ipc_send+0x3a>
        int r;
        while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
                 if(r != -E_IPC_NOT_RECV)
  801f76:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f79:	74 12                	je     801f8d <ipc_send+0x35>
                         panic("sys_ipc_try_send fails %e\n", r);
  801f7b:	50                   	push   %eax
  801f7c:	68 fa 27 80 00       	push   $0x8027fa
  801f81:	6a 39                	push   $0x39
  801f83:	68 15 28 80 00       	push   $0x802815
  801f88:	e8 97 e3 ff ff       	call   800324 <_panic>
                 sys_yield();
  801f8d:	e8 dc ed ff ff       	call   800d6e <sys_yield>
{
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
        if(!pg) pg = (void *)UTOP;
        int r;
        while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0) {
  801f92:	ff 75 14             	pushl  0x14(%ebp)
  801f95:	53                   	push   %ebx
  801f96:	56                   	push   %esi
  801f97:	57                   	push   %edi
  801f98:	e8 7d ef ff ff       	call   800f1a <sys_ipc_try_send>
  801f9d:	83 c4 10             	add    $0x10,%esp
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	78 d2                	js     801f76 <ipc_send+0x1e>
                 if(r != -E_IPC_NOT_RECV)
                         panic("sys_ipc_try_send fails %e\n", r);
                 sys_yield();
        }
                
}
  801fa4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fa7:	5b                   	pop    %ebx
  801fa8:	5e                   	pop    %esi
  801fa9:	5f                   	pop    %edi
  801faa:	5d                   	pop    %ebp
  801fab:	c3                   	ret    

00801fac <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801fb2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fb7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fba:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fc0:	8b 52 50             	mov    0x50(%edx),%edx
  801fc3:	39 ca                	cmp    %ecx,%edx
  801fc5:	75 0d                	jne    801fd4 <ipc_find_env+0x28>
			return envs[i].env_id;
  801fc7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fca:	05 40 00 c0 ee       	add    $0xeec00040,%eax
  801fcf:	8b 40 08             	mov    0x8(%eax),%eax
  801fd2:	eb 0e                	jmp    801fe2 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801fd4:	83 c0 01             	add    $0x1,%eax
  801fd7:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fdc:	75 d9                	jne    801fb7 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801fde:	66 b8 00 00          	mov    $0x0,%ax
}
  801fe2:	5d                   	pop    %ebp
  801fe3:	c3                   	ret    

00801fe4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fea:	89 d0                	mov    %edx,%eax
  801fec:	c1 e8 16             	shr    $0x16,%eax
  801fef:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ff6:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ffb:	f6 c1 01             	test   $0x1,%cl
  801ffe:	74 1d                	je     80201d <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802000:	c1 ea 0c             	shr    $0xc,%edx
  802003:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80200a:	f6 c2 01             	test   $0x1,%dl
  80200d:	74 0e                	je     80201d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80200f:	c1 ea 0c             	shr    $0xc,%edx
  802012:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802019:	ef 
  80201a:	0f b7 c0             	movzwl %ax,%eax
}
  80201d:	5d                   	pop    %ebp
  80201e:	c3                   	ret    
  80201f:	90                   	nop

00802020 <__udivdi3>:
  802020:	55                   	push   %ebp
  802021:	57                   	push   %edi
  802022:	56                   	push   %esi
  802023:	83 ec 10             	sub    $0x10,%esp
  802026:	8b 54 24 2c          	mov    0x2c(%esp),%edx
  80202a:	8b 7c 24 20          	mov    0x20(%esp),%edi
  80202e:	8b 74 24 24          	mov    0x24(%esp),%esi
  802032:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802036:	85 d2                	test   %edx,%edx
  802038:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80203c:	89 34 24             	mov    %esi,(%esp)
  80203f:	89 c8                	mov    %ecx,%eax
  802041:	75 35                	jne    802078 <__udivdi3+0x58>
  802043:	39 f1                	cmp    %esi,%ecx
  802045:	0f 87 bd 00 00 00    	ja     802108 <__udivdi3+0xe8>
  80204b:	85 c9                	test   %ecx,%ecx
  80204d:	89 cd                	mov    %ecx,%ebp
  80204f:	75 0b                	jne    80205c <__udivdi3+0x3c>
  802051:	b8 01 00 00 00       	mov    $0x1,%eax
  802056:	31 d2                	xor    %edx,%edx
  802058:	f7 f1                	div    %ecx
  80205a:	89 c5                	mov    %eax,%ebp
  80205c:	89 f0                	mov    %esi,%eax
  80205e:	31 d2                	xor    %edx,%edx
  802060:	f7 f5                	div    %ebp
  802062:	89 c6                	mov    %eax,%esi
  802064:	89 f8                	mov    %edi,%eax
  802066:	f7 f5                	div    %ebp
  802068:	89 f2                	mov    %esi,%edx
  80206a:	83 c4 10             	add    $0x10,%esp
  80206d:	5e                   	pop    %esi
  80206e:	5f                   	pop    %edi
  80206f:	5d                   	pop    %ebp
  802070:	c3                   	ret    
  802071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802078:	3b 14 24             	cmp    (%esp),%edx
  80207b:	77 7b                	ja     8020f8 <__udivdi3+0xd8>
  80207d:	0f bd f2             	bsr    %edx,%esi
  802080:	83 f6 1f             	xor    $0x1f,%esi
  802083:	0f 84 97 00 00 00    	je     802120 <__udivdi3+0x100>
  802089:	bd 20 00 00 00       	mov    $0x20,%ebp
  80208e:	89 d7                	mov    %edx,%edi
  802090:	89 f1                	mov    %esi,%ecx
  802092:	29 f5                	sub    %esi,%ebp
  802094:	d3 e7                	shl    %cl,%edi
  802096:	89 c2                	mov    %eax,%edx
  802098:	89 e9                	mov    %ebp,%ecx
  80209a:	d3 ea                	shr    %cl,%edx
  80209c:	89 f1                	mov    %esi,%ecx
  80209e:	09 fa                	or     %edi,%edx
  8020a0:	8b 3c 24             	mov    (%esp),%edi
  8020a3:	d3 e0                	shl    %cl,%eax
  8020a5:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020a9:	89 e9                	mov    %ebp,%ecx
  8020ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020af:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020b3:	89 fa                	mov    %edi,%edx
  8020b5:	d3 ea                	shr    %cl,%edx
  8020b7:	89 f1                	mov    %esi,%ecx
  8020b9:	d3 e7                	shl    %cl,%edi
  8020bb:	89 e9                	mov    %ebp,%ecx
  8020bd:	d3 e8                	shr    %cl,%eax
  8020bf:	09 c7                	or     %eax,%edi
  8020c1:	89 f8                	mov    %edi,%eax
  8020c3:	f7 74 24 08          	divl   0x8(%esp)
  8020c7:	89 d5                	mov    %edx,%ebp
  8020c9:	89 c7                	mov    %eax,%edi
  8020cb:	f7 64 24 0c          	mull   0xc(%esp)
  8020cf:	39 d5                	cmp    %edx,%ebp
  8020d1:	89 14 24             	mov    %edx,(%esp)
  8020d4:	72 11                	jb     8020e7 <__udivdi3+0xc7>
  8020d6:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020da:	89 f1                	mov    %esi,%ecx
  8020dc:	d3 e2                	shl    %cl,%edx
  8020de:	39 c2                	cmp    %eax,%edx
  8020e0:	73 5e                	jae    802140 <__udivdi3+0x120>
  8020e2:	3b 2c 24             	cmp    (%esp),%ebp
  8020e5:	75 59                	jne    802140 <__udivdi3+0x120>
  8020e7:	8d 47 ff             	lea    -0x1(%edi),%eax
  8020ea:	31 f6                	xor    %esi,%esi
  8020ec:	89 f2                	mov    %esi,%edx
  8020ee:	83 c4 10             	add    $0x10,%esp
  8020f1:	5e                   	pop    %esi
  8020f2:	5f                   	pop    %edi
  8020f3:	5d                   	pop    %ebp
  8020f4:	c3                   	ret    
  8020f5:	8d 76 00             	lea    0x0(%esi),%esi
  8020f8:	31 f6                	xor    %esi,%esi
  8020fa:	31 c0                	xor    %eax,%eax
  8020fc:	89 f2                	mov    %esi,%edx
  8020fe:	83 c4 10             	add    $0x10,%esp
  802101:	5e                   	pop    %esi
  802102:	5f                   	pop    %edi
  802103:	5d                   	pop    %ebp
  802104:	c3                   	ret    
  802105:	8d 76 00             	lea    0x0(%esi),%esi
  802108:	89 f2                	mov    %esi,%edx
  80210a:	31 f6                	xor    %esi,%esi
  80210c:	89 f8                	mov    %edi,%eax
  80210e:	f7 f1                	div    %ecx
  802110:	89 f2                	mov    %esi,%edx
  802112:	83 c4 10             	add    $0x10,%esp
  802115:	5e                   	pop    %esi
  802116:	5f                   	pop    %edi
  802117:	5d                   	pop    %ebp
  802118:	c3                   	ret    
  802119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802120:	3b 4c 24 04          	cmp    0x4(%esp),%ecx
  802124:	76 0b                	jbe    802131 <__udivdi3+0x111>
  802126:	31 c0                	xor    %eax,%eax
  802128:	3b 14 24             	cmp    (%esp),%edx
  80212b:	0f 83 37 ff ff ff    	jae    802068 <__udivdi3+0x48>
  802131:	b8 01 00 00 00       	mov    $0x1,%eax
  802136:	e9 2d ff ff ff       	jmp    802068 <__udivdi3+0x48>
  80213b:	90                   	nop
  80213c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802140:	89 f8                	mov    %edi,%eax
  802142:	31 f6                	xor    %esi,%esi
  802144:	e9 1f ff ff ff       	jmp    802068 <__udivdi3+0x48>
  802149:	66 90                	xchg   %ax,%ax
  80214b:	66 90                	xchg   %ax,%ax
  80214d:	66 90                	xchg   %ax,%ax
  80214f:	90                   	nop

00802150 <__umoddi3>:
  802150:	55                   	push   %ebp
  802151:	57                   	push   %edi
  802152:	56                   	push   %esi
  802153:	83 ec 20             	sub    $0x20,%esp
  802156:	8b 44 24 34          	mov    0x34(%esp),%eax
  80215a:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80215e:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802162:	89 c6                	mov    %eax,%esi
  802164:	89 44 24 10          	mov    %eax,0x10(%esp)
  802168:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80216c:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
  802170:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802174:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  802178:	89 74 24 18          	mov    %esi,0x18(%esp)
  80217c:	85 c0                	test   %eax,%eax
  80217e:	89 c2                	mov    %eax,%edx
  802180:	75 1e                	jne    8021a0 <__umoddi3+0x50>
  802182:	39 f7                	cmp    %esi,%edi
  802184:	76 52                	jbe    8021d8 <__umoddi3+0x88>
  802186:	89 c8                	mov    %ecx,%eax
  802188:	89 f2                	mov    %esi,%edx
  80218a:	f7 f7                	div    %edi
  80218c:	89 d0                	mov    %edx,%eax
  80218e:	31 d2                	xor    %edx,%edx
  802190:	83 c4 20             	add    $0x20,%esp
  802193:	5e                   	pop    %esi
  802194:	5f                   	pop    %edi
  802195:	5d                   	pop    %ebp
  802196:	c3                   	ret    
  802197:	89 f6                	mov    %esi,%esi
  802199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8021a0:	39 f0                	cmp    %esi,%eax
  8021a2:	77 5c                	ja     802200 <__umoddi3+0xb0>
  8021a4:	0f bd e8             	bsr    %eax,%ebp
  8021a7:	83 f5 1f             	xor    $0x1f,%ebp
  8021aa:	75 64                	jne    802210 <__umoddi3+0xc0>
  8021ac:	8b 6c 24 14          	mov    0x14(%esp),%ebp
  8021b0:	39 6c 24 0c          	cmp    %ebp,0xc(%esp)
  8021b4:	0f 86 f6 00 00 00    	jbe    8022b0 <__umoddi3+0x160>
  8021ba:	3b 44 24 18          	cmp    0x18(%esp),%eax
  8021be:	0f 82 ec 00 00 00    	jb     8022b0 <__umoddi3+0x160>
  8021c4:	8b 44 24 14          	mov    0x14(%esp),%eax
  8021c8:	8b 54 24 18          	mov    0x18(%esp),%edx
  8021cc:	83 c4 20             	add    $0x20,%esp
  8021cf:	5e                   	pop    %esi
  8021d0:	5f                   	pop    %edi
  8021d1:	5d                   	pop    %ebp
  8021d2:	c3                   	ret    
  8021d3:	90                   	nop
  8021d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021d8:	85 ff                	test   %edi,%edi
  8021da:	89 fd                	mov    %edi,%ebp
  8021dc:	75 0b                	jne    8021e9 <__umoddi3+0x99>
  8021de:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e3:	31 d2                	xor    %edx,%edx
  8021e5:	f7 f7                	div    %edi
  8021e7:	89 c5                	mov    %eax,%ebp
  8021e9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8021ed:	31 d2                	xor    %edx,%edx
  8021ef:	f7 f5                	div    %ebp
  8021f1:	89 c8                	mov    %ecx,%eax
  8021f3:	f7 f5                	div    %ebp
  8021f5:	eb 95                	jmp    80218c <__umoddi3+0x3c>
  8021f7:	89 f6                	mov    %esi,%esi
  8021f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802200:	89 c8                	mov    %ecx,%eax
  802202:	89 f2                	mov    %esi,%edx
  802204:	83 c4 20             	add    $0x20,%esp
  802207:	5e                   	pop    %esi
  802208:	5f                   	pop    %edi
  802209:	5d                   	pop    %ebp
  80220a:	c3                   	ret    
  80220b:	90                   	nop
  80220c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802210:	b8 20 00 00 00       	mov    $0x20,%eax
  802215:	89 e9                	mov    %ebp,%ecx
  802217:	29 e8                	sub    %ebp,%eax
  802219:	d3 e2                	shl    %cl,%edx
  80221b:	89 c7                	mov    %eax,%edi
  80221d:	89 44 24 18          	mov    %eax,0x18(%esp)
  802221:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802225:	89 f9                	mov    %edi,%ecx
  802227:	d3 e8                	shr    %cl,%eax
  802229:	89 c1                	mov    %eax,%ecx
  80222b:	8b 44 24 0c          	mov    0xc(%esp),%eax
  80222f:	09 d1                	or     %edx,%ecx
  802231:	89 fa                	mov    %edi,%edx
  802233:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802237:	89 e9                	mov    %ebp,%ecx
  802239:	d3 e0                	shl    %cl,%eax
  80223b:	89 f9                	mov    %edi,%ecx
  80223d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802241:	89 f0                	mov    %esi,%eax
  802243:	d3 e8                	shr    %cl,%eax
  802245:	89 e9                	mov    %ebp,%ecx
  802247:	89 c7                	mov    %eax,%edi
  802249:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  80224d:	d3 e6                	shl    %cl,%esi
  80224f:	89 d1                	mov    %edx,%ecx
  802251:	89 fa                	mov    %edi,%edx
  802253:	d3 e8                	shr    %cl,%eax
  802255:	89 e9                	mov    %ebp,%ecx
  802257:	09 f0                	or     %esi,%eax
  802259:	8b 74 24 1c          	mov    0x1c(%esp),%esi
  80225d:	f7 74 24 10          	divl   0x10(%esp)
  802261:	d3 e6                	shl    %cl,%esi
  802263:	89 d1                	mov    %edx,%ecx
  802265:	f7 64 24 0c          	mull   0xc(%esp)
  802269:	39 d1                	cmp    %edx,%ecx
  80226b:	89 74 24 14          	mov    %esi,0x14(%esp)
  80226f:	89 d7                	mov    %edx,%edi
  802271:	89 c6                	mov    %eax,%esi
  802273:	72 0a                	jb     80227f <__umoddi3+0x12f>
  802275:	39 44 24 14          	cmp    %eax,0x14(%esp)
  802279:	73 10                	jae    80228b <__umoddi3+0x13b>
  80227b:	39 d1                	cmp    %edx,%ecx
  80227d:	75 0c                	jne    80228b <__umoddi3+0x13b>
  80227f:	89 d7                	mov    %edx,%edi
  802281:	89 c6                	mov    %eax,%esi
  802283:	2b 74 24 0c          	sub    0xc(%esp),%esi
  802287:	1b 7c 24 10          	sbb    0x10(%esp),%edi
  80228b:	89 ca                	mov    %ecx,%edx
  80228d:	89 e9                	mov    %ebp,%ecx
  80228f:	8b 44 24 14          	mov    0x14(%esp),%eax
  802293:	29 f0                	sub    %esi,%eax
  802295:	19 fa                	sbb    %edi,%edx
  802297:	d3 e8                	shr    %cl,%eax
  802299:	0f b6 4c 24 18       	movzbl 0x18(%esp),%ecx
  80229e:	89 d7                	mov    %edx,%edi
  8022a0:	d3 e7                	shl    %cl,%edi
  8022a2:	89 e9                	mov    %ebp,%ecx
  8022a4:	09 f8                	or     %edi,%eax
  8022a6:	d3 ea                	shr    %cl,%edx
  8022a8:	83 c4 20             	add    $0x20,%esp
  8022ab:	5e                   	pop    %esi
  8022ac:	5f                   	pop    %edi
  8022ad:	5d                   	pop    %ebp
  8022ae:	c3                   	ret    
  8022af:	90                   	nop
  8022b0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8022b4:	29 f9                	sub    %edi,%ecx
  8022b6:	19 c6                	sbb    %eax,%esi
  8022b8:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  8022bc:	89 74 24 18          	mov    %esi,0x18(%esp)
  8022c0:	e9 ff fe ff ff       	jmp    8021c4 <__umoddi3+0x74>
