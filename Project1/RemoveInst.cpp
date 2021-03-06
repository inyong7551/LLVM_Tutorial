#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <stdlib.h>

#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Metadata.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/DiagnosticInfo.h"
#include "llvm/IR/DiagnosticPrinter.h"
#include "llvm/IR/DiagnosticHandler.h"
#include "llvm/Bitcode/BitcodeReader.h"
#include "llvm/Bitcode/BitcodeWriter.h"
#include "llvm/Transforms/Utils/ValueMapper.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/raw_os_ostream.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/FileSystem.h"

std::string input_path;
std::string output_path;
llvm::LLVMContext* TheContext;
std::unique_ptr<llvm::Module> TheModule;

void ParseIRSource(void);
void TraverseModule(void);
void PrintModule(void);

int main(int argc , char** argv)
{
	if(argc < 3)
	{
		std::cout << "Usage: ./RemoveInst <input_ir_file> <output_ir_file>" << std::endl;
		return -1;
	}
	input_path = std::string(argv[1]);
	output_path = std::string(argv[2]);

	// Read & Parse IR Source
	ParseIRSource();
	// Traverse TheModule
	TraverseModule();
	// Print TheModule to output_path
	PrintModule();

	return 0;
}

// Read & Parse IR Sources
//  Human-readable assembly(*.ll) or Bitcode(*.bc) format is required
void ParseIRSource(void)
{
	llvm::SMDiagnostic err;

	// Context
	TheContext = new llvm::LLVMContext();
	if( ! TheContext )
	{
		std::cerr << "Failed to allocated llvm::LLVMContext" << std::endl;
		exit( -1 );
	}

	// Module from IR Source
	TheModule = llvm::parseIRFile(input_path, err, *TheContext);
	if( ! TheModule )
	{
		std::cerr << "Failed to parse IR File : " << input_path << std::endl;
		exit( -1 );
	}
}

// Traverse Instructions in TheModule
void TraverseModule(void)
{
	llvm::raw_os_ostream raw_cout( std::cout );

	// Module::iterator --> Function
	for( llvm::Module::iterator ModIter = TheModule->begin(); ModIter != TheModule->end(); ++ModIter )
	{
		llvm::Function* Func = llvm::cast<llvm::Function>(ModIter);

		for( llvm::Function::iterator FuncIter = Func->begin(); FuncIter != Func->end(); ++FuncIter )
		{
			llvm::BasicBlock* BB = llvm::cast<llvm::BasicBlock>(FuncIter);
			std::vector< llvm::Instruction* > Insts;

			for( llvm::BasicBlock::iterator BBIter = BB->begin(); BBIter != BB->end(); ++BBIter )
			{
				llvm::Instruction* Inst = llvm::cast<llvm::Instruction>(BBIter);
				int val = -1;
				int i;

				if(Inst->getOpcode() == llvm::Instruction::Add){
					if(llvm::ConstantInt* CI = llvm::dyn_cast<llvm::ConstantInt>(Inst->getOperand(0))){
						if(CI->getBitWidth() <= 32 && (val = CI->getSExtValue()) == 0){
							i = 1;
						}
					}
					else if(llvm::ConstantInt* CI = llvm::dyn_cast<llvm::ConstantInt>(Inst->getOperand(1))){
						if(CI->getBitWidth() <= 32 && (val = CI->getSExtValue()) == 0){
							i = 0;
						}
					}

					if(val == 0){
						Inst->replaceAllUsesWith(Inst->getOperand(i));
						Insts.push_back(llvm::cast<llvm::Instruction>(Inst));
					}
					
				}
				else if(Inst->getOpcode() == llvm::Instruction::Mul){
					if(llvm::ConstantInt* CI = llvm::dyn_cast<llvm::ConstantInt>(Inst->getOperand(0))){
						if(CI->getBitWidth() <= 32 && (val = CI->getSExtValue()) == 1){
							i = 1;
						}
					}
					else if(llvm::ConstantInt* CI = llvm::dyn_cast<llvm::ConstantInt>(Inst->getOperand(1))){
						if(CI->getBitWidth() <= 32 && (val = CI->getSExtValue()) == 1){
							i = 0;
						}
					}

					if(val == 1){
						Inst->replaceAllUsesWith(Inst->getOperand(i));
						Insts.push_back(llvm::cast<llvm::Instruction>(Inst));
					}
				}
			}

			for(int i=0,Size=Insts.size();i<Size;i++)
				Insts[i]->eraseFromParent();
		}
	}
}

// Print TheModule to output path in human-readable format
void PrintModule(void)
{
	std::error_code err;
	llvm::raw_fd_ostream raw_output( output_path, err, llvm::sys::fs::OpenFlags::F_None );

	if( raw_output.has_error() )
	{
		std::cerr << "Failed to open output file : " << output_path << std::endl;
		exit(-1);
	}

	TheModule->print(raw_output, NULL);
	raw_output.close();
}


