git add .
git commit -m "�Զ��ύ %date% %time%" 
git push

cd gitbook
cd _book
git init
git remote add origin git@github.com:SCzfdf/gitbook.git
git add .
git commit -m "�Զ��ύ %date% %time%" 
git push origin master -f 

::pause