# LLVM_Tutorial
CASS LAB Tutorial 1 : LLVM Compiler

# [Step_1]

- Step 1에서는 ***clang, llvm-as, llvm-dis, llc*** 등의 툴을 사용하여 소스 코드 (.c)를 IR 코드 (*.bc, *.ll)로, 그리고 다시 바이너리로 컴파일하는 방법을 익힌다.
- ***clang*** : LLVM IR 기반 컴파일러로, C, C++ 등 다양한 프론트엔드를 지원
- ***llvm-as, llvm-dis*** : IR 레벨의 Assembler와 Disassembler로 이를 사용하여 human-readable assembly format (*.ll)과 bitcode format (*.bc)의 IR 코드를 각각 다른 문법으로 바꿀 수 있다.
- ***llc*** : LLVM backend compiler로 bitcode format의 LLVM IR을 Machine Assembly로 변환

```c
// HelloWorld.c
#include <stdio.h>

int main(void)
{
		printf("Hello World\n");
		return 0;
}
```

## 1. *Clang*

### (1) object file로 compile

```c
$ clang HelloWorld.c -o HelloWorld
$ ./HelloWorld

// Source Code 대신 IR Code도 Compile 가능
```

### (2) LLVM IR로 compile

```c
$ clang -emit-llvm -S HelloWorld.c -o HelloWorld.ll
$ clang -emit-llvm -c HelloWorld.c -o HelloWorld.bc
```

## 2. *llvm-as, llvm-dis*

```c
$ llvm-as HelloWorld.ll -o=HelloWorld.2.bc
$ llvm-dis HelloWorld.bc -o=HelloWorld.2.ll
```

## 3. *llc*

```c
$ llc HelloWorld.ll -o HelloWorld.s
```

## 4. *ReadIR*

```c
$ clang++ ReadIR.cpp -o ReadIR $(llvm-config --cxxflags --ldflags --system-libs --libs mcjit irreader)
```

# [Step_2]

- Step 2에서는 LLVM의 ***기본적인 Module 구조***를 이해하고, IR 내의 명령어들을 C++ iterator를 사용하여 순회 및 출력한다.
- **LLVM IR**에서는 ***llvm::Module → llvm::Function → llvm::BasicBlock → llvm::Instruction***의 계층 구조로 Target Program을 관리한다.
    - ***Module*** = 모듈, 일반적으로 하나의 Source file
    - ***Function*** = 함수
    - ***Basic Block*** = Straight Forward Code Section, Branch나 Return 같은 명령어로 끝난다.
    - ***Instruction*** = 명령어
    

```cpp
void TraverseModule(void)
{
	llvm::raw_os_ostream raw_cout( std::cout );
	
	// Module::iterator --> Function	
	for( llvm::Module::iterator ModIter = TheModule->begin(); ModIter != TheModule->end(); ++ModIter)
	{ 
		llvm::Function* Func = llvm::cast<llvm::Function>(ModIter);
		
		// Print Function Name	
		raw_cout << Func->getName() << '\n';
		
		// Function::iterator --> BasicBlock
		for( llvm::Function::iterator FuncIter = Func->begin(); FuncIter != Func->end(); ++FuncIter)
		{
			llvm::BasicBlock* BB = llvm::cast<llvm::BasicBlock>(FuncIter);
				
			// BasicBlock::iterator --> Instruction : InstListType
			for( llvm::BasicBlock::iterator BBIter = BB->begin(); BBIter != BB->end(); ++BBIter)
			{
				llvm::Instruction* Inst = llvm::cast<llvm::Instruction>(BBIter);
				
				// Print Instruction
				raw_cout << '\t';
				Inst->print(raw_cout);
				raw_cout << '\n';
			}
		}
	}
}
```

# [Step_3]
- Step 3에서 특정 Instruction의 개수를 세는 간단한 ***정적 프로파일러*** 개발
- Step 2의 TraverseModule에서 llvm::cast<llvm::Instruction>(blockIter)를 통해 Instruction Pointer를 찾고 해당 Instruction에 Method

```cpp
// CountInst.cpp

llvm::Instruction* Inst = llvm::cast<llvm::Instruction>(BBIter);

if(Inst->getOpcode() == llvm::Instruction::Add) { total_add_inst++; }
```

- 자주 사용되는 명령어
    - ***BinaryOperator*** : add, sum, mul 과 같은 산술 연산이나, add, or와 같은 비교 연산 등 2개의 Operand를 연산하는 Instruction
    - ***ReturnInst, BranchInst 등*** : Control Flow 관련 Instruction
    - ***CallInst*** : Function Call Instruction
    - ***CastInst*** : Type Casting Instruction
    - ***AllcaInst*** : Stack(Static) Allocation Instruction
    - ***LoadInst, StoreInst*** : Memory Access Instruction
    - ***GetElementPtrInst*** : Memory Access in Array Instruction
    

## Exercise 1

- add, sub, mul, div의 개수를 모두 Count

```cpp
// Exercise1.cpp

llvm::Instruction* Inst = llvm::cast<llvm::Instruction>(BBIter);

switch(Inst->getOpcode()){
	case llvm::Instruction::Add :
		total_add_inst++;
		break;
	case llvm::Instruction::Sub :
		total_sub_inst++;
		break;
	case llvm::Instruction::Mul :
		total_mul_inst++p;
		break;
	case llvm::Instruction::SDiv :
		// llvm::Instrution에는 세가지 Division이 존재
		// SDiv = Signed Division, UDiv = Unsigned Division, FDiv = Floating-point Division
		total_div_inst++;
		break;
	default:
		break;
}
```

## Exercise 2


- 어떤 함수가 몇 번씩 호출되었는지 정적으로 Count

```cpp
// Exercise.2
// Function의 중복을 막기 위해 Map을 사용
std::map<std::string, int> m;

// ...
llvm::Instruction* Inst = llvm::case<llvm::Instruction>(BBIter);

if(Inst->getOpcode() == llvm::Instruction::Call){
	llvm::Function* cFunc = llvm::cast<llvm::CallInst>(Inst)->getCalledFunction();
	if(m.find(cFunc->getName().str()) != m.end()){
		m[cFunc->getName().str()] += 1;
	}
	else{
		m.insert({cFunc->getName().str(), 1});
	}
}
// ...

for(auto it = m.begin(); it != m.end(); it++){
	std::cout << "The Number of Function Call " << it->first << " in the Module "
<< TheModule->getName().str() << " is " << it->second << std::endl;
```

# [Step_4]

- Step 4에서 IR Level에서 Program 내의 ***Instruction을 삭제하거나 새로 생성하여 삽입***
    1. 새로운 Instruction을 생성
    2. 기존 Instruction을 삭제
    3. Instruction 간 Dependency에 문제가 없도록 새로운 Instruction으로 기존 Instruction을 대체

## Instruction Insertion


```cpp
// InsertInst.cpp

llvm::Instruction* Inst = llvm::cast<llvm::Instruction>(BBIter);

if(Inst->getOpcode() == llvm::Instruction::Add)
{ 
	llvm::BinaryOperator::Create(
		llvm::Instruction::Add,
		llvm::ConstantInt::get( llvm::IntegerType::get( *TheContext, 32 ), 1, true),
		llvm::ConstantInt::get( llvm::IntegerType::get( *TheContext, 32 ), 1, true),
		"addtmp",
		Inst);
}
```

## Instruction Deletion



- 특정 Instruction을 삭제하기 위해서는 해당 Instruction의 결과 값을 사용하는 명령어들의 DU Chain을 해결해주어야 한다.
- Target Application의 ADD Instruction을 SUB Instruction으로 바꾸는 과정을 수행하는데, 이를 위해
    - ADD Instruction과 같은 피연산자들로 SUB Instruction을 생성
    - ADD Instruction의 결과 값이 사용되는 곳 (USE)들을 SUB Instruction의 결과를 사용하도록 변경
    - 최후에 ADD Instruction을 삭제

```cpp
// ReplaceInst.cpp
for(llvm::Function::iterator FuncIter = Func->begin(); FuncIter != Func->end(); ++FuncIter){
	llvm::BasicBlock* BB = llvm::cast<llvm::BasicBlock>(FuncIter);
	std::vector<llvm::Instruction*> AddInsts;
	
	for(llvm::BasicBlock::iterator BBIter = BB->begin(); BBIter != BB->end(); ++BBIter){
		llvm::Instruction* AddInst = llvm::cast<llvm::Instruction>(BBIter);

		if( AddInst->getOpcode() == llvm::Instruction::Add )
		{
			// (1) Target Application에서, 원래 ADD 명령어와 같은 Operand로, ADD 명령어 이전에 
			// SUB 명령어가 수행되도록 코드를 변경
			
			llvm::Instruction* SubInst = llvm::BinaryOperator::Create(
				llvm::Instruction::Sub,
				AddInst->getOperand(0),
				AddInst->getOperand(1),
				"subtmp",
				AddInst);
			
			// (2) 생성한 SUB 명령어가 ADD 명령어가 사용되는 곳에 대신하여 사용되도록 코드를 변경
			AddInst->replaceAllUsesWith( SubInst );
			AddInst.push_back( AddInst );
		}
	}
	
	// (3) ADD 명령어를 삭제. 단, 현재 BBIter가 삭제할 명령어를 가리키고 있기 때문에
	// Loop 내에서 삭제하면 오류가 발생하므로 Loop 밖에서 삭제
	for(int i=0, Size=AddInsts.size(); i<Size; ++i) AddInsts[i]->eraseFromParent();
}
```

## Exercise 1



- 앞서의 Step 4에서 (2)의 코드를 삭제한 이후 ((3)은 수행), 어떤 문제가 발생하는지 확인합니다.
- ***Expectation***
    - RepalceInst.cpp의 원리는 다음과 같다.
        1. Old Inst 앞에 New Inst Insert
        2. Old Inst의 결과 값을 사용하는 Inst들을 New Inst의 결과 값으로 사용하도록 변경
        3. Old Inst 삭제
    - (2)의 코드를 삭제한다는 것은 Old Inst의 결과 값을 사용하는 Inst들을 New Inst의 결과 값으로 사용하도록 변경하지 않는다는 것을 의미한다.
    - (2)의 코드를 삭제한 채, (3)의 코드를 실행하게 되면 Old Inst의 결과 값을 사용하던 모든 Inst에서 오류가 발생
- ***Result***
    - 아래 사진은 정상적으로 변경된 IR 코드와 (2)의 코드를 실행하지 않은 채 변경된 IR 코드의 비교이다.
    - 오른쪽과 같이 ***<badref>***를 띄는 것으로 보아 예측이 맞는 것 같다.

![1.PNG](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/140d6569-afbb-4aab-aeff-d9fdc93b21e2/1.png)

## Exercise 2


- A + B + C의 연산 패턴을 탐색하고, 이를 A * B - C로 변경합니다.
    - 연산 순서상, A + B + C는 (A + B) + C와 같은데, 이것은 A + B 명령어의 결과 값이 ADD 명령어의 Operand로 들어가는 것과 같습니다.

```cpp
// Temp.c
#include <stdio.h>

int main(void){
	int a = 3;
	int b = 4;
	int c = 5;
	int d = a + b + c;

	return 0;
}
```

- 위의 Temp.c를 IR Code로 변환하면 아래와 같다.

```cpp
// Temp.ll
...
; Function Attrs: noinline nounwind optnone uwtable
define i32 @main() #0 {
	%1 = alloca i32, align 4 // main의 return value
	%2 = alloca i32, align 4 // define a
	%3 = alloca i32, align 4 // define b
	%4 = alloca i32, align 4 // define c
	%5 = alloca i32, align 4 // define d
  store i32 0, i32* %1, align 4 // allocate 0 to return value 
  store i32 3, i32* %2, align 4 // allocate 3 to a
  store i32 4, i32* %3, align 4 // allocate 4 to b
  store i32 5, i32* %4, align 4 // allocate 5 to c
	%6 = load i32, i32* %2, align 4 // a의 값을 잠시 저장할 중간 value
	%7 = load i32, i32* %3, align 4 // b의 값을 잠시 저장할 중간 value
	%8 = add nsw i32 %6, %7 // a + b의 값을 잠시 저장할 중간 value
 	%9 = load i32, i32* %4, align 4 // c의 값을 저장할 중간 value
	%10 = add nsw i32 %8, %9 // (a + b) + c의 값을 잠시 저장할 중간 value
	store i32 %10, i32* %5, align 4 // %10의 값을 d에 저장
	ret i32 0
}
...
```

- 위의 Code를 아래와 같이 변경시켜야 한다.

```cpp
// changed from "%8 = add nsw i32 %6, %7"
%multmp = mul i32 %6, %7
%subtmp = sub i32 %multmp, %8
```

```cpp
// Exercise2.cpp
for(llvm::Function::iterator FuncIter = Func->begin(); FuncIter != Func->end(); ++FuncIter){
	llvm::BasicBlock* BB = llvm::cast<llvm::BasicBlock>(FuncIter);
	std::vector<llvm::Instruction*> Insts;
	
	for(llvm::BasicBlock::iterator BBIter = BB->begin(); BBIter != BB->end(); ++BBIter){
		llvm::Instruction* Inst = llvm::cast<llvm::Instruction>(BBIter);

		if( Inst->getOpcode() == llvm::Instruction::Add )
		{
			if( Inst->getOperand(0)->getName().str().compare("multmp") != 0){
				llvm::Instruction* MulInst = llvm::BinaryOperator::Create(
					llvm::Instruction::Mul,
					Inst->getOperand(0),
					Inst->getOperand(1),
					"multmp",
					Inst);
			
				Inst->replaceAllUsesWith( MulInst );
				Inst.push_back( Inst );
			} else {
				llvm::Instruction* SubInst = llvm::BinaryOperator::Create(
					llvm::Instruction::Sub,
					Inst->getOperand(0),
					Inst->getOperand(1),
					"subtmp",
					Inst);

				Inst->replaceAllUsesWith( SubInst );
				Inst.push_back( Inst );
			}
		}
	}

	for(int i=0, Size=Insts.size(); i<Size; ++i) Insts[i]->eraseFromParent();
}
```
  
# [Step_5]
  
  - Step 5에서는 IR Level에서 명령어의 위치를 변경하고, **메모리 명령어의 종속 관계**에 대해서 파악합니다.
- 메모리 명령어의 종속 관계는 컴파일러 입장에서 대부분 알기 어렵습니다. 예를 들어 주소 X에서 값을 읽은 명령어와 주소 Y에 값을 저장하는 명령어가 있다고 할 때, 주소 X와 주소 Y가 같거나, 다르다는 보장이 없는 이상 두 명령어간 순서는 두 명령어간 def-use chain에서 종속 관계가 없다고 하더라도 쉽게 바뀔 수 없습니다.
- Step 5에서는 Store 명령어를 Store 명령어가 있는 Basic Block 가장 마지막 부분으로 위치를 옮기는 작업을 수행합니다.
- 앞서 설명한 것의 이유로, Store 명령어의 위치 이동으로 이루어지는 종속성 문제는 컴파일러 레벨에서 특별한 오류를 발생시키지 않습니다.

```cpp
//MoveInst.cpp
...
std::vector< llvm::StoreInst* > StoreInsts;
llvm::Instruction* LastInst;

for( llvm::BasicBlock::iterator BBIter = BB->begin(); BBIter != BB->end(); ++BBIter)
{
	llvm::Instruction* Inst = llvm::cast<llvm::Instruction>(BBIter);
	
	// (1) 프로그램 내의 Store Instruction 식별
	if( llvm::isa< llvm::StoreInst >( Inst ) )
	{
		StoreInsts.push_back( llvm::cast< llvm::StoreInst >( Inst ));
	}

	// (2) Basic Block 내의 마지막 명령어 탐색
	LastInst = Inst;
}

for( int i=0, Size=StoreInsts.size(); i<Size; ++i)
{
	// (3) 마지막 명령어 바로 앞에 Store Instruction Insert
	StoreInsts[i]->moveBefore(LastInst);
}
```

- ***Result***
    - BB 내의 모든 Store Instruction이 Last Instruction 바로 앞에 모여 있는 것을 볼 수 있다.
    - 출력 결과는 오류 → Store-Load 관계에 신중

![2.PNG](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/88a0109e-7a01-4594-ba79-336e4e2d7c51/2.png)

![3.PNG](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/147d5759-2db0-410a-bf2c-27104cd97a05/3.png)

## Exercise

- Store 명령어가 접근하는 주소를 바탕으로, 불필요한 Load를 삭제합니다.
    - Load와 Store 사이에 다른 메모리 접근 명령어가 없고, 주소가 같은 것을 완전히 보장 할 수 있는 경우에만 Load 명령어의 결과 값 대신 Store에 저장하는 값 (레지스터에 저장된)을 사용할 수 있습니다.
- ***Optimization***
    1. Store Instruction에서 값을 저장한 주소에 Load Instruction이 다시 값을 가져오는 경우
    2. Load Instruction에 Destination Operand를 Source Operand로 사용하는 Instruction들을 Store Instruction의 값으로 대체
    3. Load Instruction 삭제

```cpp
// Exercise.cpp
...
std::vector< llvm::LoadInst* > LoadInsts;

llvm:Instruction* Inst = llvm::cast<llvm::Instruction>(BBIter);

if( llvm::isa< llvm::StoreInst >( Inst ) ){
	// (1) LoadInsts 초기화
	LoadInsts.clear();
	
	// (2) StoreInst의 저장공간을 사용하는 Instruction의 집합
	//  이 집합은 역순으로 쌓여있다.
	for(llvm::User *user : Inst->getOperand(1)->users()){
		// (3) Instruction으로 Casting
		if(llvm::Instruction *i = llvm::dyn_cast<llvm::Instruction>(user)){
			// (4) LoadInst일 경우 저장
			if(llvm::isa< llvm::LoadInst >( i ))
				LoadInsts.push_back(llvm::cast< llvm:LoadInst >( i ));
			else if( llvm::isa< llvm::StoreInst >( i )){
				if(i == Inst) break;
				// (5) Load-Store 사이에 Store가 존재하면 초기화
				LoadInsts.clear();
			]
		}
	}
	
	for(int i=0, Size=LoadInsts.size(); i<Size; i++){
		// (6) 해당 LoadInst의 종속 관계 해제
		LoadInsts[i]->replaceAllUsesWith(Inst->getOperand(0));
		// (7) LoadInst 삭제
		LoadInsts[i]->eraseFromParent();
	}
}
...
```

- ***Result***

![4.PNG](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/a8ac5fa0-7d5d-4696-a362-dde7ff9fefea/4.png)

![2.PNG](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/7d91523d-4b7a-45b7-a942-7bad0e13d40e/2.png)
  
# [Project 1]
  - 간단한 ***수학적 최적화*** 수행 ~ ***Simple*** ***Constant Folding***
- A가 Integer Data일 때, A + 0과 A * 1은 둘 다 결과 값이 A이다. 즉, 컴파일 단계에서 판단 할 수 있는 쓸모 없는 연산으로 일반적으로 삭제된다.
    - ***Input*** : 임의의 C Program의 IR
    - ***Output*** : A = A + 0, A = A * 1 명령어가 지워진 IR

- ***Implementation***
    - ***Optimization Target***을 선별
        - *%Dest = add %Src, 0*
        - *%Dest = add 0, %Src*
        - *%Dest = mul %Src, 1*
        - *%Dest = mul 1, %Src*
        
        ⇒ 위의 Instruction과 종속 관계에 있는 Instruction의 Use를 %Src로 바꾸어주고 Loop 밖에서 위의 Instruction을 삭제
        

```cpp
// RemoveInst.cpp

std::vector< llvm::Instruction* > Insts;
for( llvm::BasicBlock::iterator BBIter = BB->begin(); BBIter != BB->end(); ++BBIter){
	llvm::Instruction* Inst = llvm::cast<llvm::Instruction>(BBIter);
	int val = -1;
	int i;
	
	// ADD Instruction
	if(Inst->getOpcode() == llvm::Instruction::Add){
		// %Dest = add 0, %Src
		if(llvm::ConstantInt* CI = llvm::dyn_cast<llvm::ConstantInt>(Inst->getOperand(0))){
			if(CI->getBitWidth() <= 32 && (val = CI->getSExtValue())
				i = 1;
		}
		// %Dest = add %Src, 0
		else if(llvm::ConstantInt* CI = llvm::dyn_cast<llvm::ConstantInt>(Inst->getOperand(1))){
			if(CI->getBitWidth() <= 32 && (val = CI->getSExtValue())
				i = 0;	
		}

		if(val == 0){
			Inst->replaceAllUsesWith(Inst->getOperand(i));
			Insts.push_back(llvm::cast<llvm::Instruction(Inst));
		}
	}
	// MUL Instruction
	else if(Inst->getOpcode() == llvm::Instruction::Mul){
		// ADD Instruction일때와 유사
	}
}

for(int i=0,Size=Insts.size();i<Size;i++)
	Insts[i]->eraseFromParent();
```

- ***Result***
    - *Test.ll* 과 *Test.Exercise.ll* 비교
        - 정상적으로 최적화가 된 것을 볼 수 있다.
    
    ![1.PNG](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/93b37a39-d80f-4850-b138-a51ba4d648e3/1.png)
    
    - *Test.Processed.ll* 과 *Test.Exercise.ll* 비교
        - 동일한 IR Code를 나타낸다
    
    ![2.PNG](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/e38fd934-c5eb-4364-95a2-8e8594d54adb/2.png)
  
# [Project 2]
  - 간단한 ***동적 프로파일러*** 개발
    - Step 3에서의 정적 프로파일러는 Loop에서 존재하는 Instruction을 IR Code만 보고 Count하기 때문에 Trip Count가 아무리 크더라도 1로 계산된다.
    - 따라서, 실제 프로그램을 실행하면서 Instruction을 세는 동적 프로파일러를 개발한다.
    - ***Input*** : 임의의 C Program의 IR. 0으로 초기화된 i32 전역 변수 add_inst_count가 프로그램 내에 존재한다고 가정
    - ***Output*** : 프로그램 내의 Add Instruction이 실행될 때마다 add_inst_count += 1을 바로 직전 (또는 직후)에 실행하도록 추가한 IR
    - ***Note*** : 전역 변수의 값을 업데이트하기 위해서는 load-add-store의 과정이 필요
        
        프로그램 마지막 부분에서 add_inst_count를 출력
        
    
- ***Implementation***
    - Step 4와 다르게, Instruction을 만들기 위해 IRBuilder를 사용하였다.
    - Global Variable을 Increment하기 위해서는 load-add-store의 과정이 필요하므로, 총 3개의 Instruction을 삽입해야 한다.
        - ***%tmp = load i32, i32* @add_inst_count***
        - ***%(Dest) = add i32 1, %tmp***
        - ***store i32 %(Dest), i32* @add_inst_count***
    

```cpp
// InsertInst.cpp

llvm::Instruction* Inst = llvm::cast<llvm::Instruction>(BBIter);

if(Inst->getOpcode() == llvm::Instruction::Add){
	// (1) IRBuilder<> IR(Inst) : 새로운 Instruction을 삽입할 Point를 Inst 바로 직전으로 설정
	llvm::IRBuilder<> IR(Inst);
	// (2) Global Variable로 설정한 add_inst_count를 Module 단위에서 접근
	llvm::Value* gValue = TheModule->getGlobalVariable("add_inst_count");
	// (3) %tmp에 gValue를 담는 Load Instruction 생성
	llvm::LoadInst* loadInst = IR.CreateLoad(gValue, "tmp");
	// (4) loadInst 다음에 1을 추가하는 Add Instruction 생성
	llvm::Value* inc = IR.CreateAdd(IR.getInt32(1), loadInst);
	// (5) inc의 결과 Register를 다시 gValue 주소에 저장하는 Store Instruction 생성
	llvm::StoreInst* storeInst = IR.CreateStore(inc, gValue);
}
```

- ***Result***
    - ADD Instruction 앞에, 아래 3개의 Instruction이 제대로 삽입되어 있는 것을 확인할 수 있다.
        - ***%tmp = load i32, i32* @add_inst_count***
        - ***%(Dest) = add i32 1, %tmp***
        - ***store i32 %(Dest), i32* @add_inst_count***
    - 실행 결과, ADD Instruction이 Dynamic Counting 된 것을 알 수 있다.

![1.PNG](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/5efb9a65-b651-49b0-b4e0-110b7e3ca71a/1.png)

![2.PNG](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/3321d560-dcfb-4582-8005-646ee04ef2d2/2.png)
