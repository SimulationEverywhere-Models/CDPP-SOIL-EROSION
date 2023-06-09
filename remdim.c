#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define BUFF_SIZE 200

typedef enum {FALSE,TRUE}BOOLEAN;

void stringIn3Dimensions(char inputLine[],int* fourthDimension,char trimmedString[],
								BOOLEAN firstDimensionIsSelected);
int findCharacter(char inputLine[],char charachter);

/*works in 4 dimensions, must specify the length of the fourth dimension*/
int main(int argc,char* argv[])
{
	FILE* inputFile;
	FILE** outputFiles;
	int doneReading;
	char inputLine[BUFF_SIZE];
	int fourthDimension;
	char trimmedString[BUFF_SIZE];
	int lengthOfFourth;
	char outputFileName[BUFF_SIZE];
	char firstPart[BUFF_SIZE];
	char extension[BUFF_SIZE];
	int counter;
	int index;
/*	int commonLines=0;*/
	BOOLEAN firstDimensionIsSelected=FALSE;
	BOOLEAN usageError=FALSE;
	char inputFileName[BUFF_SIZE];
/*
	char* argv[2]={"hello","2"};
	int argc=2;
*/
	if(argc < 3)
		usageError=TRUE;
	else
		while(--argc)
			if(*argv[argc]!='-')
				usageError=TRUE;
			else
			{
				switch(argv[argc][1])
				{
					case 'd':
						lengthOfFourth=atoi(argv[argc]+2);
						break;
					case 'f':
						firstDimensionIsSelected=TRUE;
						break;
					case 'l':
						sscanf(argv[argc]+2,"%s",inputFileName);
						break;
					default:
						usageError=TRUE;
				}
			}

	if(usageError)
	{
		fprintf(stderr,"error using remdim: remdim -dLENGTH_OF_4TH_DIMESION -lLOG_FILE_NAME [-f]\n");
		exit(-1);
	}

	if(!lengthOfFourth)
	{
		fprintf(stderr,"error using remdim: invalid length for fourth dimension\n");
		exit(-1);
	}

	outputFiles=(FILE**)malloc(sizeof(FILE*)*lengthOfFourth);

	if((inputFile=fopen(inputFileName,"rt"))==NULL)
	{
		fprintf(stderr,"unable ot open %s\n",inputFileName);
		exit(-1);
	}

	for(counter=0;counter<lengthOfFourth;counter++)
	{
		index=findCharacter(inputFileName,'.');
		strncpy(firstPart,inputFileName,index);
		strcpy(extension,inputFileName+index);
		sprintf(outputFileName,"%s%d%s",firstPart,counter,extension);
		if((outputFiles[counter]=fopen(outputFileName,"wt"))==NULL)
		{
			fprintf(stderr,"unable ot open %s\n",outputFileName);
			exit(-1);
		}
	}

	doneReading=0;

	//find lines with at least 4 dimensions, therefore (.+,.+,.+,.+)
	while(!doneReading)
	{
		if(fgets(inputLine,BUFF_SIZE-1,inputFile)==NULL)
			doneReading=1;
		else
		{
			stringIn3Dimensions(inputLine,
										&fourthDimension,
										trimmedString,
										firstDimensionIsSelected);
			if(fourthDimension!=-1)
				fputs(trimmedString,outputFiles[fourthDimension]);
			else//write it to all files if fourthDimension is not present
			{
				/*++commonLines;*/
				for(counter=0;counter<lengthOfFourth;counter++)
					fputs(trimmedString,outputFiles[counter]);
			}
		}
	}

	/*this was used for debugging
	printf("There are %d common lines\n",commonLines);*/

	for(counter=0;counter<lengthOfFourth;counter++)
		fclose(outputFiles[counter]);

	return 0;
}

void stringIn3Dimensions(char inputLine[],
								int* fourthDimension,
								char trimmedString[],
								BOOLEAN firstDimensionIsSelected)
{
	char inputLineBackup[BUFF_SIZE];
	int leftBracketIndex;
	int rightBracketIndex;
	int commaIndex;
	int cummulativeIndex;
	int cummulativeCommaIndex;
	int commaCounter;
	int found;
	int done;

	strcpy(inputLineBackup,inputLine);

	done=0;
	found=0;
	cummulativeIndex=-1;
	while(!done)
	{
			leftBracketIndex=findCharacter(inputLine+cummulativeIndex+1,'(');
			leftBracketIndex+=cummulativeIndex+1;

			cummulativeCommaIndex=leftBracketIndex;
			for(commaCounter=0;commaCounter<3;commaCounter++)
			{
				commaIndex=findCharacter(inputLine+cummulativeCommaIndex+1,',');
				cummulativeCommaIndex+=commaIndex+1;
				if(!commaIndex)
					break;
			}

			if(commaCounter==3)
			{
				rightBracketIndex=findCharacter(inputLine+leftBracketIndex+1,')');
				rightBracketIndex+=leftBracketIndex+1;
				if(cummulativeCommaIndex < rightBracketIndex)
				{
					if(firstDimensionIsSelected)
					{
						sscanf(inputLine+leftBracketIndex+1,"%d",fourthDimension);
						strncpy(trimmedString,inputLine,leftBracketIndex+1);
						trimmedString[leftBracketIndex+1]='\0';
						commaIndex=findCharacter(inputLine+leftBracketIndex+1,',');
						strcat(trimmedString,inputLine+leftBracketIndex+1+commaIndex+1);
					}
					else
					{
						sscanf(inputLine+cummulativeCommaIndex+1,"%d",fourthDimension);
						strncpy(trimmedString,inputLine,cummulativeCommaIndex);
						trimmedString[cummulativeCommaIndex]='\0';
						strcat(trimmedString,inputLine+rightBracketIndex);
					}
					found=1;
					done=1;
				}
				else
					cummulativeIndex=rightBracketIndex;
			}
			else
			{
				*fourthDimension=-1;
				done=1;
			}
	 }

	 if(!found)
		strcpy(trimmedString,inputLineBackup);
}

int findCharacter(char inputLine[],char character)
{
	int counter;
	int length=strlen(inputLine);

	for(counter=0;counter<length;counter++)
		if(inputLine[counter]==character)
			break;

	/*if no character was found*/
	if(counter==length)
		return 0;
	else
		return counter;
}
