#include "stdafx.h"
#include "LandProject_EN.h"

char CLandProject_EN::GetSpecialLegendChar(char* legendName)
{
	char  SpecialLegendChar[] = {'f','x','z','c','l'};
	int legendCharIndex = -1;	

	if (strcmp(legendName,"��ɰ")==0)
	{
		strcpy(pHatch->m_Name,"ɰ");
		legendCharIndex = 0;	
	}
	else if (strcmp(legendName,"��ϸɰ")==0)
	{
		strcpy(pHatch->m_Name,"ɰ");
		legendCharIndex = 0;	
	}
	else if (strcmp(legendName,"��ɰ��ϸɰ")==0)
	{
		strcpy(pHatch->m_Name,"ɰ");
		legendCharIndex = 0;	
	}
	else if (strcmp(legendName,"��ɰ�з���")==0)
	{
		strcpy(pHatch->m_Name,"ɰ");
		legendCharIndex = 0;	
	}
	else if (strcmp(legendName,"ϸɰ")==0)
	{
		strcpy(pHatch->m_Name,"ɰ");
		legendCharIndex = 1;	
	}
	else if (strcmp(legendName,"��ɰ")==0)
	{
		strcpy(pHatch->m_Name,"ɰ");
		legendCharIndex = 2;	
	}
	else if (strcmp(legendName,"��ϸɰ")==0)
	{
		strcpy(pHatch->m_Name,"ɰ");
		legendCharIndex = 2;	
	}
	else if (strcmp(legendName,"�д�ɰ")==0)
	{
		strcpy(pHatch->m_Name,"ɰ");
		legendCharIndex = 2;	
	}
	else if (strcmp(legendName,"��ɰ")==0)
	{
		strcpy(pHatch->m_Name,"ɰ");
		legendCharIndex = 3;	
	}
	else if (strcmp(legendName,"��ɰ")==0)
	{
		strcpy(pHatch->m_Name,"ɰ");
		legendCharIndex = 4;	
	}
	else if (strcmp(legendName,"��ɰ��")==0)
	{
		strcpy(pHatch->m_Name,"ɰ��");
		legendCharIndex = 0;	
	}
	else if (strcmp(legendName,"ϸɰ��")==0)
	{
		strcpy(pHatch->m_Name,"ɰ��");
		legendCharIndex = 1;	
	}
	else if (strcmp(legendName,"��ɰ��")==0)
	{
		strcpy(pHatch->m_Name,"ɰ��");
		legendCharIndex = 2;	
	}
	else if (strcmp(legendName,"��ɰ��")==0)
	{
		strcpy(pHatch->m_Name,"ɰ��");
		legendCharIndex = 3;	
	}
	else if (strcmp(legendName,"������ɰ��")==0)
	{
		legendCharIndex = 0;	
	}
	/*else if (strcmp(legendName,"��ɰ�з���")==0)
	{
		strcpy(pHatch->m_Name,"ɰ�ʷ���");
		legendCharIndex = 0;	
	}*/
	else if (strcmp(legendName,"����ɰ����ճ��")==0)
	{
		legendCharIndex = 4;	
	}
	else if (strcmp(legendName,"����ɰճ��")==0)
	{
		legendCharIndex = 4;	
	}
	else if (strcmp(legendName,"����ɰ�����ʷ���ճ��")==0)
	{
		legendCharIndex = 4;	
	}
	else if (strcmp(legendName,"��ճ������ɳ")==0)
	{
		legendCharIndex = 0;	
	}
	else if (strcmp(legendName,"��ճ����ϸɳ")==0)
	{
		legendCharIndex = 1;	
	}
	else if (strcmp(legendName,"��ճ������ɳ")==0)
	{
		legendCharIndex = 2;	
	}
	else if (strcmp(legendName,"��ճ������ɳ")==0)
	{
		legendCharIndex = 3;	
	}
	else if (strcmp(legendName,"��ճ������ɳ")==0)
	{
		legendCharIndex = 4;	
	}
	
	if (legendCharIndex > -1)
		return SpecialLegendChar[legendCharIndex];
	else
		return SpecialLegendChar[' '];
}