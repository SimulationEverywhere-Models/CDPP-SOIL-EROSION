/*******************************************************************
*
*  DESCRIPTION: class Generator
*
*  AUTHOR: Joseph Gammal and Toqueer Israr
*
*  PURPOSE: To generate an output every 100.
*
*******************************************************************/

/** include files **/
#include "generator.h"       // base header
#include "message.h"       // class InternalMessage 
#include "mainsimu.h"      // class Simulator
#include "distri.h"
#include "realfunc.h"

const int TIME_OUT=50;

/*******************************************************************
* Function Name: Generator
* Description: constructor
********************************************************************/
Generator1::Generator1( const string &name )
: Atomic( name )
, out( addOutputPort( "out" ) )
{
}

/*******************************************************************
* Function Name: initFunction
********************************************************************/
Model &Generator1::initFunction()
{
	holdIn( active, Time(0,0,0,TIME_OUT)) ;
	return *this ;
}

/*******************************************************************
* Function Name: internalFunction
********************************************************************/
Model &Generator1::internalFunction( const InternalMessage & )
{
	holdIn( active, Time(0,0,0,TIME_OUT) ) ;

	return *this ;
}

/*******************************************************************
* Function Name: outputFunction
********************************************************************/
Model &Generator1::outputFunction( const InternalMessage &msg )
{
	int value;

	value=(randomSign(0.5).value()>0 ? 1 : 0);

	cout << msg.time() << " " << (value ? "rain drop\n" : "no rain drop\n");

	sendOutput( msg.time(), out,value); 
	return *this ;
}

Generator1::~Generator1()
{
}
