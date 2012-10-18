{ *********************************************************************** }
{                                                                         }
{ SdCadMath unit                                                          }
{                                                                         }
{ Copyright (c) 2003 SD Software Corporation                              }
{                                                                         }
{This unit is math unit for the project}
{ *********************************************************************** }
unit SdCadMath;

interface
uses SysUtils,Math,public_unit;

//ȡ����Ʒ������Ӧ������ֵ���ٽ�ֵ
//��ʽ:f(x)= (x-x1)/(x0-x1)*y0+(x-x0)/(x1-x0)*y1
function GetCriticalValue(aSampleNum: integer): double;

//����TAnalyzeResult��������������ƽ��ֵ����׼�����ϵ��������ֵ��
procedure GetTeZhengShu(var aAnalyzeResult : TAnalyzeResult; Flags: TTongJiFlags);

//����TAnalyzeResult��������������ƽ��ֵ����׼�����ϵ��������ֵ��
//�˺�����Ϊ��������ѧͳ��ʱ����̽���ݲ������޳������˸Ķ���2005/07/11 yys edit
procedure GetTeZhengShuWLLX(var aAnalyzeResult : TAnalyzeResult);

{ *********************************************************************** }
{ �������ֲ��ܱ�,��Ȼ״̬�Ļ�������ָ�����ͼ�����õĿ�����ָ��ļ���   }
{ *********************************************************************** }
{GetGanMiDu: return���ܶ�,AHanShuiLiang��ˮ��,AShiMiDuʪ�ܶ�,
���ܶ�=ʪ�ܶ�/(1+0.01*��ˮ��) }
function GetGanMiDu(const AHanShuiLiang: double; const AShiMiDu: double): double;

{GetKongXiBi: return��϶��,ATuLiBiZhong��������,AGanMiDu���ܶ�,AShuiMiDuˮ�ı���,
��϶��=(��������*ˮ�ı���)/���ܶ�-1 }
function GetKongXiBi(const ATuLiBiZhong: double; const AGanMiDu: double; const AShuiMiDu: double=1): double;

{GetKongXiDu: return��϶��,AKongXiBi��϶��,
��϶��=(100*��϶��)/(1+��϶��) }
function GetKongXiDu(const AKongXiBi: double): double;

{GetBaoHeDu: return���϶�,AHanShuiLiang��ˮ��,ATuLiBiZhong��������,AKongXiBi��϶��,
���϶�=��ˮ��*��������/��϶��}
function GetBaoHeDu(const AHanShuiLiang: double; const ATuLiBiZhong: double; const AKongXiBi: double): double;

{GetSuXingZhiShu: return����ָ��,AYeXianҺ��,ASuXian����,
����ָ��=Һ��-����}
function GetSuXingZhiShu(const AYeXian: double; const ASuXian: double): double;

{GetYeXingZhiShu: returnҺ��ָ��,AHanShuiLiang��ˮ��,ASuXian����,AYeXianҺ��,
Һ��ָ��=(��ˮ��-����)/(Һ��-����)}
function GetYeXingZhiShu(const AHanShuiLiang: double; const ASuXian: double;const AYeXian: double ): double;

{******************************************************************}
{**********��ֵ�㷨************************************************}
{******************************************************************}
{XianXingChaZhi: ���β�ֵ
  ��ʽ:f(x)= (x-x1)/(x0-x1)*y0+(x-x0)/(x1-x0)*y1}
function XianXingChaZhi(x0, y0, x1, y1, x: double): double;

{ShuangXianXingChaZhi: ���β�ֵ
  ��ʽ:f(x)= (x-x1)/(x0-x1)*y0+(x-x0)/(x1-x0)*y1}
function ShuangXianXingChaZhi(x0, y0, x1, y1, zx0y0,zx0y1, zx1y0, zx1y1, x, y: double): double;

implementation

uses MainDM;


function GetGanMiDu(const AHanShuiLiang: double; const AShiMiDu: double): double;
begin
  try
    result:= AShiMiDu / (1 + 0.01 * AHanShuiLiang);
  except
    result:= 0;
  end;
end;

function GetKongXiBi(const ATuLiBiZhong: double; const AGanMiDu: double; const AShuiMiDu: double=1): double;
begin
  result:= ATuLiBiZhong * AShuiMiDu / AGanMiDu - 1;
end;

function GetKongXiDu(const AKongXiBi: double): double;
begin
  result:=100 * AKongXiBi / (1 + AKongXiBi);
end;

function GetBaoHeDu(const AHanShuiLiang: double; const ATuLiBiZhong: double; const AKongXiBi: double): double;
begin
  result:= AHanShuiLiang * ATuLiBiZhong / AKongXiBi;
  if result>100 then result:= 100;
end;

function GetSuXingZhiShu(const AYeXian: double; const ASuXian: double): double;
begin
  result:= AYeXian - ASuXian;
end;

function GetYeXingZhiShu(const AHanShuiLiang: double; const ASuXian: double;const AYeXian: double ): double;
begin
  result:= (AHanShuiLiang - ASuXian) / (AYeXian - ASuXian);
end;

function XianXingChaZhi(x0, y0, x1, y1, x: double): double;
begin
  result:= (x - x1) / (x0 - x1) * y0 + (x - x0) / (x1-x0) * y1;
end;

function ShuangXianXingChaZhi(x0, y0, x1, y1, zx0y0,zx0y1, zx1y0, zx1y1, x, y: double): double;
var
  tmpz0,tmpz1: double;
begin
  tmpz0:= XianXingChaZhi(x0, zx0y0, x1, zx1y0, x);
  tmpz1:= XianXingChaZhi(x0, zx0y1, x1, zx1y1, x);
  result:= XianXingChaZhi(y0, tmpz0, y1, tmpz1, y);
end;

//ȡ����Ʒ������Ӧ������ֵ���ٽ�ֵ
//��ʽ:f(x)= (x-x1)/(x0-x1)*y0+(x-x0)/(x1-x0)*y1
function GetCriticalValue(aSampleNum: integer): double;
var
  iNum: integer;
  x0,y0,x1,y1,tmpX,tmpY: double;
begin
  x0:=0;
  y0:=0;
  with MainDataModule.qrySectionTotal do
  begin
    close;
    sql.Clear;
    sql.Add('SELECT yangpinshu,zhixinshuiping95 FROM CriticalValue');
    open;
    iNum:= 0;
    while not eof do
    begin
      inc(iNum);
      tmpX:= FieldbyName('yangpinshu').AsInteger;
      tmpY:= FieldbyName('zhixinshuiping95').AsFloat;
      if aSampleNum= tmpX then
      begin
        result:= tmpY;
        close;
        exit;
      end;
      if iNum=1 then 
        begin
          x0:= tmpX;
          y0:= tmpY;
          if aSampleNum<x0 then
          begin
            result:= tmpY;
            close;
            exit;
          end;
        end
      else
        begin
          if (aSampleNum<tmpX) then
            begin
              x1:=tmpX;
              y1:=tmpY;
              result:= StrToFloat(formatfloat('0.00',XianXingChaZhi(x0, y0, x1, y1, aSampleNum)));
              close;
              exit;
            end
          else
            begin
              x0:= tmpX;
              y0:= tmpY;
            end;
        end; 
      next;
    end;
    close;
  end;
  result:= y0;
end;

//����TAnalyzeResult��������������ƽ��ֵ����׼�����ϵ��������ֵ��
procedure GetTeZhengShu(var aAnalyzeResult : TAnalyzeResult; Flags: TTongJiFlags);
var
  i,iCount,iFirst,iMin,iMax:integer;
  dTotal,dValue,dTotalFangCha,dCriticalValue:double;
  strValue: string;
  //�����ٽ�ֵ
  function CalculateCriticalValue(aValue, aPingjunZhi, aBiaoZhunCha: double): double;
  begin
    if aBiaoZhunCha = 0 then
    begin
      result:= 0;
      exit;
    end;
    result := (aValue - aPingjunZhi) / aBiaoZhunCha;
  end;
begin
  iMax:=0;
  dTotal:= 0;
  iFirst:= 0;
  dTotalFangCha:=0;
//yys 2005/06/15
//  aAnalyzeResult.PingJunZhi := 0;
//  aAnalyzeResult.BiaoZhunCha := 0;
//  aAnalyzeResult.BianYiXiShu := 0;
//  aAnalyzeResult.MaxValue := 0;
//  aAnalyzeResult.MinValue := 0;
//  aAnalyzeResult.SampleNum := 0;
  aAnalyzeResult.PingJunZhi := -1;
  aAnalyzeResult.BiaoZhunCha := -1;
  aAnalyzeResult.BianYiXiShu := -1;
  aAnalyzeResult.MaxValue := -1;
  aAnalyzeResult.MinValue := -1;
  aAnalyzeResult.SampleNum := -1;
  if aAnalyzeResult.lstValues.Count<1 then exit;
  strValue := '';
  for i:= 0 to aAnalyzeResult.lstValues.Count-1 do
      strValue:=strValue + aAnalyzeResult.lstValues.Strings[i];
  strValue := trim(strValue);
  if strValue='' then exit;

//yys 2005/06/15
  iCount:= aAnalyzeResult.lstValues.Count;
  for i:= 0 to aAnalyzeResult.lstValues.Count-1 do
    begin
      strValue:=aAnalyzeResult.lstValues.Strings[i];
      if strValue='' then
      begin
        iCount:=iCount-1;
      end
      else
      begin
        inc(iFirst);
        dValue:= StrToFloat(strValue); 
        if iFirst=1 then
          begin
            aAnalyzeResult.MinValue:= dValue;
            aAnalyzeResult.MaxValue:= dValue;
            iMin := i;
            iMax := i;
          end
        else
          begin
            if aAnalyzeResult.MinValue>dValue then
            begin
              aAnalyzeResult.MinValue:= dValue;
              iMin := i;
            end;
            if aAnalyzeResult.MaxValue<dValue then
            begin
              aAnalyzeResult.MaxValue:= dValue;
              iMax := i;
            end;                            
          end;           
        dTotal:= dTotal + dValue;          
      end;
    end;
  //dTotal:= dTotal - aAnalyzeResult.MinValue - aAnalyzeResult.MaxValue;
  //iCount := iCount - 2;
  if iCount>=1 then
    aAnalyzeResult.PingJunZhi := dTotal/iCount
  else
    aAnalyzeResult.PingJunZhi := dTotal;
  //aAnalyzeResult.lstValues.Strings[iMin]:= '';
  //aAnalyzeResult.lstValues.Strings[iMax]:= '';

  //iCount:= aAnalyzeResult.lstValues.Count;
  for i:= 0 to aAnalyzeResult.lstValues.Count-1 do
  begin
    strValue:=aAnalyzeResult.lstValues.Strings[i];
    if strValue<>'' then
    begin
      dValue := StrToFloat(strValue);
      dTotalFangCha := dTotalFangCha + sqr(dValue-aAnalyzeResult.PingJunZhi);
    end
    //else iCount:= iCount -1;
  end;
  if iCount>1 then
    dTotalFangCha:= dTotalFangCha/(iCount-1);
  aAnalyzeResult.SampleNum := iCount;
  if iCount >1 then
    aAnalyzeResult.BiaoZhunCha := sqrt(dTotalFangCha)
  else
    aAnalyzeResult.BiaoZhunCha := sqrt(dTotalFangCha);
  if not iszero(aAnalyzeResult.PingJunZhi) then
    aAnalyzeResult.BianYiXiShu := strtofloat(formatfloat(aAnalyzeResult.FormatString,aAnalyzeResult.BiaoZhunCha / aAnalyzeResult.PingJunZhi))
  else
    aAnalyzeResult.BianYiXiShu:= 0;


  dValue:= CalculateCriticalValue(aAnalyzeResult.MaxValue, aAnalyzeResult.PingJunZhi,aAnalyzeResult.BiaoZhunCha);
  dCriticalValue := GetCriticalValue(iCount);

//2005/07/25 yys edit ���������޳�ʱ����6�����Ͳ����޳����޳�ʱҪ���޳���������
  if tfTuYang in Flags then

      if (iCount> 6) AND (dValue > dCriticalValue) then
        begin
          aAnalyzeResult.lstValues.Strings[iMax]:= '';
          if aAnalyzeResult.lstValuesForPrint.Strings[iMax]<>'' then
            aAnalyzeResult.lstValuesForPrint.Strings[iMax]:= '-'
              +aAnalyzeResult.lstValuesForPrint.Strings[iMax];
          GetTeZhengShu(aAnalyzeResult, Flags);
        end

  else if tfJingTan in Flags  then //��̽���޳�����    tfOtherҲ���޳�
  else if tfBiaoGuan in Flags  then
        if dValue > dCriticalValue then
        begin
          aAnalyzeResult.lstValues.Strings[iMax]:= '';
          aAnalyzeResult.lstValuesForPrint.Strings[iMax]:= '-'
            +aAnalyzeResult.lstValuesForPrint.Strings[iMax];          
          GetTeZhengShu(aAnalyzeResult, Flags);
        end;


//yys 2005/06/15 add, ��һ��ֻ��һ����ʱ����׼��ͱ���ϵ������Ϊ0����ӡ����ʱҪ�ÿո�������ѧ��Ҳһ����������-1����ʾ��ֵ������Ϊ�ڱ������ʱ����ͨ���ж�����ʾΪ�ա�
  if  iCount=1 then
  begin
     //aAnalyzeResult.strBianYiXiShu  := 'null';
     //aAnalyzeResult.strBiaoZhunCha  := 'null';
     aAnalyzeResult.BianYiXiShu := -1;
     aAnalyzeResult.BiaoZhunCha := -1;
  end
  else begin
     //aAnalyzeResult.strBianYiXiShu := FloatToStr(aAnalyzeResult.BianYiXiShu);
    // aAnalyzeResult.strBiaoZhunCha := FloatToStr(aAnalyzeResult.BiaoZhunCha);
  end;
//yys 2005/06/15 add
end;


//����TAnalyzeResult��������������ƽ��ֵ����׼�����ϵ��������ֵ��
procedure GetTeZhengShuWLLX(var aAnalyzeResult : TAnalyzeResult);
var
  i,iCount,iFirst,iMin,iMax:integer;
  dTotal,dValue,dTotalFangCha,dCriticalValue:double;
  strValue: string;
  //�����ٽ�ֵ
  function CalculateCriticalValue(aValue, aPingjunZhi, aBiaoZhunCha: double): double;
  begin
    if aBiaoZhunCha = 0 then
    begin
      result:= 0;
      exit;
    end;
    result := (aValue - aPingjunZhi) / aBiaoZhunCha;
  end;
begin
  iMax:=0;
  dTotal:= 0;
  iFirst:= 0;
  dTotalFangCha:=0;
//yys 2005/06/15
//  aAnalyzeResult.PingJunZhi := 0;
//  aAnalyzeResult.BiaoZhunCha := 0;
//  aAnalyzeResult.BianYiXiShu := 0;
//  aAnalyzeResult.MaxValue := 0;
//  aAnalyzeResult.MinValue := 0;
//  aAnalyzeResult.SampleNum := 0;
  aAnalyzeResult.PingJunZhi := -1;
  aAnalyzeResult.BiaoZhunCha := -1;
  aAnalyzeResult.BianYiXiShu := -1;
  aAnalyzeResult.MaxValue := -1;
  aAnalyzeResult.MinValue := -1;
  aAnalyzeResult.SampleNum := -1;
  if aAnalyzeResult.lstValues.Count<1 then exit;
  strValue := '';
  for i:= 0 to aAnalyzeResult.lstValues.Count-1 do
      strValue:=strValue + aAnalyzeResult.lstValues.Strings[i];
  strValue := trim(strValue);
  if strValue='' then exit;

//yys 2005/06/15
  iCount:= aAnalyzeResult.lstValues.Count;
  for i:= 0 to aAnalyzeResult.lstValues.Count-1 do
    begin
      strValue:=aAnalyzeResult.lstValues.Strings[i];
      if strValue='' then
      begin
        iCount:=iCount-1;
      end
      else
      begin
        inc(iFirst);
        dValue:= StrToFloat(strValue); 
        if iFirst=1 then
          begin
            aAnalyzeResult.MinValue:= dValue;
            aAnalyzeResult.MaxValue:= dValue;
            iMin := i;
            iMax := i;
          end
        else
          begin
            if aAnalyzeResult.MinValue>dValue then
            begin
              aAnalyzeResult.MinValue:= dValue;
              iMin := i;
            end;
            if aAnalyzeResult.MaxValue<dValue then
            begin
              aAnalyzeResult.MaxValue:= dValue;
              iMax := i;
            end;                            
          end;           
        dTotal:= dTotal + dValue;          
      end;
    end;
  //dTotal:= dTotal - aAnalyzeResult.MinValue - aAnalyzeResult.MaxValue;
  //iCount := iCount - 2;
  if iCount>=1 then
    aAnalyzeResult.PingJunZhi := dTotal/iCount
  else
    aAnalyzeResult.PingJunZhi := dTotal;
  //aAnalyzeResult.lstValues.Strings[iMin]:= '';
  //aAnalyzeResult.lstValues.Strings[iMax]:= '';

  //iCount:= aAnalyzeResult.lstValues.Count;
  for i:= 0 to aAnalyzeResult.lstValues.Count-1 do
  begin
    strValue:=aAnalyzeResult.lstValues.Strings[i];
    if strValue<>'' then
    begin
      dValue := StrToFloat(strValue);
      dTotalFangCha := dTotalFangCha + sqr(dValue-aAnalyzeResult.PingJunZhi);
    end
    //else iCount:= iCount -1;
  end;
  if iCount>1 then
    dTotalFangCha:= dTotalFangCha/(iCount-1);
  aAnalyzeResult.SampleNum := iCount;
  if iCount >1 then
    aAnalyzeResult.BiaoZhunCha := sqrt(dTotalFangCha)
  else
    aAnalyzeResult.BiaoZhunCha := sqrt(dTotalFangCha);
  if not iszero(aAnalyzeResult.PingJunZhi) then
    aAnalyzeResult.BianYiXiShu := strtofloat(formatfloat(aAnalyzeResult.FormatString,aAnalyzeResult.BiaoZhunCha / aAnalyzeResult.PingJunZhi))
  else
    aAnalyzeResult.BianYiXiShu:= 0;


  dValue:= CalculateCriticalValue(aAnalyzeResult.MaxValue, aAnalyzeResult.PingJunZhi,aAnalyzeResult.BiaoZhunCha);
  dCriticalValue := GetCriticalValue(iCount);
//  if dValue > dCriticalValue then
//  begin
//    aAnalyzeResult.lstValues.Strings[iMax]:= '';
//    GetTeZhengShuWLLX(aAnalyzeResult);
//  end;

//yys 2005/06/15 add, ��һ��ֻ��һ����ʱ����׼��ͱ���ϵ������Ϊ0����ӡ����ʱҪ�ÿո�������ѧ��Ҳһ����������-1����ʾ��ֵ������Ϊ�ڱ������ʱ����ͨ���ж�����ʾΪ�ա�
  if  iCount=1 then
  begin
     //aAnalyzeResult.strBianYiXiShu  := 'null';
     //aAnalyzeResult.strBiaoZhunCha  := 'null';
     aAnalyzeResult.BianYiXiShu := -1;
     aAnalyzeResult.BiaoZhunCha := -1;
  end
  else begin
     //aAnalyzeResult.strBianYiXiShu := FloatToStr(aAnalyzeResult.BianYiXiShu);
    // aAnalyzeResult.strBiaoZhunCha := FloatToStr(aAnalyzeResult.BiaoZhunCha);
  end;
//yys 2005/06/15 add
end;


end.
