/*******************************************************************
*
*  DESCRIPTION: Simulator::registerNewAtomics()
*
*  AUTHOR: Amir Barylko & Jorge Beyoglonian 
*
*  EMAIL: mailto://amir@dc.uba.ar
*         mailto://jbeyoglo@dc.uba.ar
*
*  DATE: 27/6/1998
*
*******************************************************************/

#include "modeladm.h" 
#include "mainsimu.h"
#include "generator.h"    // class Generator
#include "trafico.h"    // class Trafico

void MainSimulator::registerNewAtomics()
{
	SingleModelAdm::Instance().registerAtomic(NewAtomicFunction<Generator1>() , "Generator" ) ;
}
