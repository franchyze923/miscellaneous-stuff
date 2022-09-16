from ftplib import FTP
from dateutil import parser
import datetime
import os

ftp = FTP('xxx.xxx.x.x')
ftp.login("admin", "xxxxx")


def get_dirs_ftp(folder=""):
    contents = ftp.nlst(folder)
    folders = []
    for item in contents:
        if "." not in item:
            folders.append(item)
    return folders


def get_all_dirs_ftp(folder=""):
    dirs = []
    new_dirs = get_dirs_ftp(folder)

    while len(new_dirs) > 0:

        for dir in new_dirs:
            dirs.append(dir)

        old_dirs = new_dirs[:]
        new_dirs = []

        for dir in old_dirs:
            for new_dir in get_dirs_ftp(dir):
                new_dirs.append(new_dir)

    dirs.sort()
    return dirs


ftp_dirs = get_all_dirs_ftp('Front Cam/2022/')

count = 0
for x in sorted(ftp_dirs):
    files = ftp.mlsd(x)

    print(f"Directory Found! : {x}")
    for file in files:
        name = file[0]

        if (file[1]['type']) == "file":
            file_date = parser.parse(file[1]['modify'])

            if file_date < datetime.datetime.now() - datetime.timedelta(days=5):
                print(f"{file[0]} is older than 4 days.. Deleting...")
                full_file_path = os.path.join(x, name)
                ftp.delete(full_file_path)
            count += 1

print(count)
