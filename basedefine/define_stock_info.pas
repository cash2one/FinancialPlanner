unit define_stock_info;

interface
      
type
  TStockInfoType = (inf_Undefine,
    inf_EPS,      // earnings per share
    inf_PE_LYR,   //  price earning ratio
    inf_PE_TTM,   //  price earning ratio
    inf_GeneralCapital,
    inf_NAPS,     // ÿ�ɾ��ʲ� net asset per share
    inf_PB,       // �о���
    inf_Flow,
    inf_DPS,
    inf_PS
  );

const
  StockInfoKeyWord: array[TStockInfoType] of String = ('',
    'ÿ������',
    '��̬��ӯ��', // ��ӯ��LYR ��̬��ӯ�� ��ӯ��TTM ��̬��ӯ��
    '��̬��ӯ��', // ��ӯ��LYR ��̬��ӯ�� ��ӯ��TTM ��̬��ӯ��
    '�ܹɱ�',   // capitalization
    'ÿ�ɾ��ʲ�',
    '�о���',       // ÿ�ɹɼ���ÿ�ɾ��ʲ��ı���
    '��ͨ�ɱ�',  // capital stock in circulation  / Flow of equity
    'ÿ�ɹ�Ϣ',  // Dividend Per Share
    '������'  // ������( Price-to-sales,PS), PS = ����ֵ ������Ӫҵ��������� PS=�ɼ� ����ÿ�����۶�
    );

implementation

end.
