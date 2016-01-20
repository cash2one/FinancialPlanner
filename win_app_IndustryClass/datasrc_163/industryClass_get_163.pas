unit industryClass_get_163;

interface

uses
  BaseApp;

  procedure GetIndustryClass_163(App: TBaseApp);

implementation

uses
  Windows,
  Sysutils,
  Classes,
  UtilsHttp,
  Define_Price,
  Define_DealItem,
  Define_DataSrc,     
  UtilsDateTime,
  
  DB_DealItem,
  DB_DealItem_Load,
  DB_DealItem_Save;

(*
  ֤�����ҵ(��)

  http://quotes.money.163.com/old/#query=HS
  
  http://quotes.money.163.com/old/#query=leadIndustry
  http://quotes.money.163.com/old/#query=leadIndustry&DataType=industryPlate&sort=PERCENT&order=desc&count=25&page=0 ������ҵ
  http://quotes.money.163.com/old/#query=leadRegion&DataType=regionPlate&sort=PERCENT&order=desc&count=25&page=0 ���ǵ���
  http://quotes.money.163.com/old/#query=leadNotation&DataType=notationPlate&sort=PERCENT&order=desc&count=25&page=0 ���Ǹ���          

  ��ý����
  http://quotes.money.163.com/old/#query=hy003011&DataType=HS_RANK&sort=PERCENT&order=desc&count=24&page=0

  ũ������
  http://quotes.money.163.com/old/#query=hy001000&DataType=HS_RANK&sort=PERCENT&order=desc&count=24&page=0
  �ɿ�ҵ
  ��ʳ�ӹ�
  ʳƷ����
  �������
  ��֯ҵ
  ��װ����
  Ƥë��Ь
  ľ�ļӹ�
  �Ҿ�����
  ��ֽӡˢ
  ��ý����
  ʯ�ͼӹ�
  ��ѧ��Ʒ
  ҽҩ����
  ��������
  ������
  �ǽ�����Ʒ
  ��ɫ����
  ��ɫ����
  ������Ʒ
  ͨ���豸����
  ר���豸����
  ��������
  �����豸
  ��������
  ͨ���豸
  �����Ǳ�
  ��������ҵ
  ��Ʒ����
  ˮ��ȼ��
  ����ҵ
  ��������
  ��ͨ����
  �����Ƶ�
  ��Ϣ����
  ����ҵ
  ���ز�ҵ
  ���޺�����
  ���м���
  ���λ���
  ��������
  ���洫ý
  �ۺ�
  ======================================================
  ����
  ======================================================
  3D��ӡ  4G  ����  �ִ�����  �ιɻ���  ������  ������
  ��Ͷ  ������  �ྦྷ��  ������  ���������  ����  ��ʿ��
  ��������  �ֲ�����  ���  ������Դ  �߶˰׾�  �㶫��������
  �㶫���ɸ���  ���  ���ʰ�  ����  �˵����������  �ƽ��
  ����������  ��ĸ����װ��  ��ĸ�촬  ���Ϲ������ε�
  ��ˮ����  ��ͬ��Դ����  ���󹤳�  IPV6  ����  ������
  ����  ��������  ����  ú����  �����й�  ũҩ  ƻ��
  �ڻ�  ǰ������  ���  �Ϻ�����  �Ϻ���ó��  �ֻ�֧��  ˮ������
  ʯīϩ  ��ɳ  �����ں�  ��·����  ������  ������Ϸ  ���ǵ���
  ����Դ����  ������  ϡ������  ҽҩ  ҳ����  ���ܴ���  ���ܵ���  ըҩ
*)
procedure GetIndustryClass_163(App: TBaseApp);
begin
end;

end.
