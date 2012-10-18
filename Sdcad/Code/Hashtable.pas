//�����ҵ���delphi hashtable, delphi7��ͨ�����ԣ������汾û�в��ԣ�Ū����ֻ����Ϊ����������о���
// �ҿ����˵Ķ����˵�ע�ͣ�����û���ˡ�
//
//Java �е� Hashtable ��С�ɺ��ã���������Ϊ�����˹�ϣ�㷨�����ҵ��ٶ���졣������
//������Ҫ��ʹ�� Delphi ʵʩһЩ��Ŀ���ر�ϰ��û�й�ϣ������ӡ����Ǿ����Լ�������
//һ����
//���ذ�����ң�Delphi ����һ�� THashedStringList �࣬��λ�� IniFiles ��Ԫ�С�������
//��һ������Ĺ�ϣ�㷨�������ͻ�Ļ����ǡ�����ַ������������װ��װ���ͳ����Լ���
//�ˡ������������𱬳�¯��������������µ� Hashtable ���ú���ģ����

//ʹ�������ͼ��ˣ�
//HashTable := THashTable.Create(); //����
//HashTable.Put(Key, Value);       //��ֵ
//Value=HashTable.Get(Key);       //ȡֵ
//HashTable.Destroy;           //����
unit Hashtable;
 
    interface
 
    uses SysUtils, Classes;
 
    type
      { THashTable }
 
      PPHashItem = ^PHashItem;               //ָ��ָ���ָ�룬����ݲ�����
      PHashItem = ^THashItem;                 //�������涨��ļ�¼���ṹ�壩��ָ��
      THashItem = record                          //�ⶨ����һ����¼���ṹ�壩
      Next: PHashItem;
      Key: string;
      Value: String;
      end;                                              //��������ṹ�����������˵�������
 
      THashTable = class                          //��ʼ��������
      private
      Buckets: array of PHashItem;                           //һ��ָ������
      protected
      function Find(const Key: string): PPHashItem; //ͨ��string������ָ���¼���ָ��
      function HashOf(const Key: string): Cardinal; virtual;//Cardinal��֪���Ӵ�delphiʱ�仹������virtualӦ���������˺���Ϊ�麯����
      public
      constructor Create(Size: Integer = 256);
      destructor Destroy; override;
      procedure Put(const Key: string; Value: String);
      procedure Clear;
      procedure Remove(const Key: string);
      function Modify(const Key: string; Value: String): Boolean;
      function Get(const Key: string): String;
      end;
 
    implementation
 
    { THashTable }
 
    procedure THashTable.Put(const Key: string; Value: String);
    var
      Hash: Integer;
      Bucket: PHashItem;
    begin
      Hash := HashOf(Key) mod Cardinal(Length(Buckets));   //����hashֵ
      New(Bucket);                                                          //�½�һ���ڵ�
      Bucket^.Key := Key;
      Bucket^.Value := Value;
      Bucket^.Next := Buckets[Hash];//���ָ��ò��ָ�����Լ������ҿ����ˣ�
      Buckets[Hash] := Bucket;                   // ���ڵ�ָ����뵽���飬����hashֵ
    end;
 
    procedure THashTable.Clear;       //�����ԣ�ѭ���ͷſռ䣬�������
    var                                      
      I: Integer;
      P, N: PHashItem;
    begin
      for I := 0 to Length(Buckets) - 1 do
      begin
      P := Buckets[I];
      while P <> nil do
      begin
        N := P^.Next;
        Dispose(P);
        P := N;
      end;
      Buckets[I] := nil;
      end;
    end;
 
   constructor THashTable.Create(Size: Integer);//��ʼ��hashtable���Ǹ�ָ������
    begin
      inherited Create;
      SetLength(Buckets, Size); 
    end;
 
    destructor THashTable.Destroy;
    begin
      Clear;
      inherited;
    end;
 
    function THashTable.Find(const Key: string): PPHashItem;
    var
      Hash: Integer;
    begin
      Hash := HashOf(Key) mod Cardinal(Length(Buckets));
      Result := @Buckets[Hash];
      while Result^ <> nil do
      begin
      if Result^.Key = Key then
        Exit
      else
        Result := @Result^.Next;
      end;
    end;
 
    function THashTable.HashOf(const Key: string): Cardinal;
    var
      I: Integer;
    begin
      Result := 0;
      for I := 1 to Length(Key) do
      Result := ((Result shl 2) or (Result shr (SizeOf(Result) * 8 - 2))) xor
        Ord(Key[I]);
    end;
 
    function THashTable.Modify(const Key: string; Value: String): Boolean;
    var
      P: PHashItem;
    begin
      P := Find(Key)^;
      if P <> nil then
      begin
      Result := True;
      P^.Value := Value;
      end
      else
      Result := False;
    end;
 
    procedure THashTable.Remove(const Key: string);
    var
      P: PHashItem;
      Prev: PPHashItem;
    begin
      Prev := Find(Key);
      P := Prev^;
      if P <> nil then
      begin
      Prev^ := P^.Next;
      Dispose(P);
      end;
    end;
 
    function THashTable.Get(const Key: string): String;
    var
      P: PHashItem;
    begin
      P := Find(Key)^;
      if P <> nil then
      Result := P^.Value else
      Result := '';
    end;
 
    end.
