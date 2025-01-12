from ftplib import FTP
from dateutil import parser
import datetime
import os

ftp = FTP('ip')
ftp.login("user", "pass")


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


front_cam = 'Front Cam/2025'
indoor_cam = 'Indoor Cam/2025'

big_list = [get_all_dirs_ftp(front_cam), get_all_dirs_ftp(indoor_cam)]

for cam in big_list:

    total_count = 0
    del_count = 0
    for x in sorted(cam):
        files = ftp.mlsd(x)

        print(f"Directory Found! : {x}")
        for file in files:
            name = file[0]

            if (file[1]['type']) == "file":
                file_date = parser.parse(file[1]['modify'])

                if file_date < datetime.datetime.now() - datetime.timedelta(days=8):
                    print(f"{file[0]} is older than 8 days.. Deleting...")
                    ## added replace below for windows path 2025
                    full_file_path = os.path.join(x, name).replace("\\","/")
                    #full_file_path = os.path.join(x, name)
                    ftp.delete(full_file_path)
                    del_count +=1
                total_count += 1

    print(f"Total Dirs: {total_count}")
    print(f"Total files deleted: {del_count}")