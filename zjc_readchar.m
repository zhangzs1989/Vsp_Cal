function charstr=zjc_readchar(fid,n)
% Matlab �� fread ���Զ������뷽ʽ��ȡ�����ܽ�һ�����ֶ���һ��char��
% ���ֽڶ�ȡ�������� C ���Ե�ϰ�ߣ��ַ�����ֹ��\00
		charstr='';
		tmpstr= fread(fid,n,'uint8');
		tmpstr= tmpstr';
		tmpind= find(tmpstr==0,1,'first');
		if tmpind>1
		charstr= (tmpstr(1:tmpind-1));
		end


