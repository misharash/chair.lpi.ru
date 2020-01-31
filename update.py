#!/usr/bin/env python3
#parameter -nu (no upload)
import sys,os,csv,urllib.request
def GetURL(url):
    s = 'error'
    try:
        f = urllib.request.urlopen(url)
        s = f.read()
    except urllib.error.HTTPError:
        s = 'connect error'
    except urllib.error.URLError:
        s = 'url error'
    return s
download_from,save_to,replace_from,replace_to,ftype,depth=[],[],[],[],[],[]
with open('resources.csv') as csvfile:
    csv_iter=csv.reader(csvfile,delimiter=';')
    next(csv_iter)
    for row in csv_iter:
        download_from.append(row[0])
        save_to.append(row[1])
        replace_from.append(row[2])
        replace_to.append(row[3])
        ftype.append(row[4])
        depth.append(0)
content_dir="chair-lpi"
saveto_dir="static/"
base_url="http://localhost:8888/"
os.chdir(content_dir)
wk=os.walk(".")
for row in wk:
    dp=row[0].count("/")
    try:
        os.mkdir("../"+saveto_dir+row[0])
    except FileExistsError:
        print("Dir exists in destination "+row[0])
    for filen in row[2]:
        if filen[-3:]==".md":
            filename=row[0]+'/'+filen[:-3]
            filename=filename[2:]
            download_from.append(base_url+"?"+filename)
            save_to.append(filename+".html")
            replace_from.append(base_url+"?"+filename.replace("/","%2F"))
            replace_to.append(filename+".html")
            ftype.append('text')
            depth.append(dp)
os.chdir("..")
for i in range(len(download_from)):
    print(download_from[i]+" -> "+save_to[i])
    bs=GetURL(download_from[i])
    if ftype[i]=="text":
        try:
            s=bs.decode("utf-8")
        except AttributeError:
            s=bs
        s=s.replace('href="http',"donotrepeatthiscombinationinapage")
        s=s.replace('href="mailto',"donotrepeatalsothiscombinationinapage")
        s=s.replace('href="','href="'+"../"*depth[i])
        s=s.replace("donotrepeatalsothiscombinationinapage",'href="mailto')
        s=s.replace("donotrepeatthiscombinationinapage",'href="http')
        s=s.replace('src="http',"donotrepeatthiscombinationinapage")
        s=s.replace('src="','src="'+"../"*depth[i])
        s=s.replace("donotrepeatthiscombinationinapage",'src="http')
        for j in range(len(replace_from)-1,-1,-1):
            s=s.replace(replace_from[j],"../"*depth[i]+replace_to[j])
        bs=s.encode("utf-8")
    with open(saveto_dir+save_to[i],"wb") as f:
        f.write(bs)
os.chdir(saveto_dir)
if ((len(sys.argv)<=1) or (sys.argv[1]!="-nu")):
    print(os.popen("scp -r . edigaryev@td.lpi.ru:/home/www/chair/new/").read())
