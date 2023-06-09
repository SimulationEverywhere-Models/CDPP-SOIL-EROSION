/*******************************************************************
*
*  DESCRIPTION: class Generator
*
*  AUTHOR: Joseph Gammal and Toqueer Israr
*
*  PURPOSE: To generate an output every 100.
*
*******************************************************************/
#ifndef __GENERAtor1_H
#define __GENERAtor1_H

/** include files **/
#include "atomic.h"     // class Atomic
#include "except.h"     // class InvalidMessageException

/** forward declarations **/
class Distribution ;

/** declarations **/
class Generator1 : public Atomic
{
public:
	Generator1( const string &name = "Generator" );				  // Default constructor

	~Generator1();

	virtual string className() const
		{return "Generator";}

protected:
	Model &initFunction() ;

	Model &externalFunction( const ExternalMessage & )
			{throw InvalidMessageException();}

	Model &internalFunction( const InternalMessage & );

	Model &outputFunction( const InternalMessage & );

private:
	Port &out ;
};	// class Generator


#endif   //__GENERAtor1_H 
