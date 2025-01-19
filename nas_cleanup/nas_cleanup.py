import logging
from ftplib import FTP
from dateutil import parser
import datetime
import os

# ------------------------------------------------------------------------
# 1. Generate a date-based log filename
# ------------------------------------------------------------------------
today_str = datetime.datetime.now().strftime("%Y-%m-%d")
log_filename = f"cleanup_log_{today_str}.txt"

# ------------------------------------------------------------------------
# 2. Configure logging
# ------------------------------------------------------------------------
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

# Create a file handler (writes log to "cleanup_log_YYYY-MM-DD.txt")
file_handler = logging.FileHandler(log_filename)
file_handler.setLevel(logging.INFO)

# (Optional) Create a console handler (prints log to console)
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.INFO)

# Define a log format
formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
file_handler.setFormatter(formatter)
console_handler.setFormatter(formatter)

# Add handlers to the logger
logger.addHandler(file_handler)
logger.addHandler(console_handler)

# ------------------------------------------------------------------------
# 3. Connect to FTP
# ------------------------------------------------------------------------
ftp = FTP('')
ftp.login("", "")

def get_dirs_ftp(folder=""):
    """Return immediate subdirectories of 'folder'."""
    try:
        entries = list(ftp.mlsd(folder))
    except Exception as e:
        logger.error(f"Error listing {folder}: {e}")
        return []
    
    folders = []
    for name, facts in entries:
        if facts.get('type') == 'dir' and name not in ('.', '..'):
            full_path = os.path.join(folder, name).replace("\\", "/")
            folders.append(full_path)
    return folders

def get_all_dirs_ftp(folder=""):
    """Return all nested subdirectories under 'folder' using a stack-based approach."""
    dirs = []
    stack = [folder]

    while stack:
        current = stack.pop()
        subdirs = get_dirs_ftp(current)
        dirs.extend(subdirs)
        stack.extend(subdirs)

    dirs.sort()
    return dirs

def delete_old_files_in_ftp_dirs(dir_list, days=6):
    """
    Delete files older than 'days' days in each directory from 'dir_list'.
    Also track and display total space saved in both MB and GB.
    """
    total_count = 0
    del_count = 0
    space_saved_bytes = 0  # Accumulate total bytes deleted

    for d in dir_list:
        logger.info(f"Directory Found: {d}")
        try:
            files = ftp.mlsd(d)
        except Exception as e:
            logger.error(f"Could not list files in {d}: {e}")
            continue
        
        for file_name, facts in files:
            if facts.get('type') == 'file':
                modify_time = facts.get('modify')
                file_size_str = facts.get('size', '0')  # default to '0' if size is missing

                # Skip if there's no modify time
                if not modify_time:
                    continue

                # Convert the 'modify' string to a datetime
                file_date = parser.parse(modify_time)

                # Check if the file is older than 'days'
                if file_date < datetime.datetime.now() - datetime.timedelta(days=days):
                    logger.info(f"{file_name} is older than {days} days... Deleting...")
                    full_file_path = os.path.join(d, file_name).replace("\\", "/")
                    
                    # Convert file_size_str to an integer (bytes)
                    try:
                        file_size = int(file_size_str)
                    except ValueError:
                        file_size = 0  # fallback if it's not a valid integer

                    # Attempt deletion
                    try:
                        ftp.delete(full_file_path)
                        del_count += 1
                        space_saved_bytes += file_size
                    except Exception as e:
                        logger.error(f"ERROR deleting {full_file_path}: {e}")
                total_count += 1

    # Convert bytes to megabytes and gigabytes
    space_saved_mb = space_saved_bytes / (1024 * 1024)
    space_saved_gb = space_saved_bytes / (1024 * 1024 * 1024)

    logger.info(f"Total files scanned: {total_count}")
    logger.info(f"Total files deleted: {del_count}")
    logger.info(f"Total space saved: {space_saved_mb:.2f} MB ({space_saved_gb:.2f} GB)")

if __name__ == "__main__":
    front_cam = 'Front Cam/2025'
    indoor_cam = 'Indoor Cam/2025'

    # Gather directories
    front_dirs = get_all_dirs_ftp(front_cam)
    indoor_dirs = get_all_dirs_ftp(indoor_cam)

    # Delete old files (and see space saved) in front camera directories
    delete_old_files_in_ftp_dirs(front_dirs, days=6)
    
    # Delete old files (and see space saved) in indoor camera directories
    delete_old_files_in_ftp_dirs(indoor_dirs, days=6)

    # Close FTP connection
    ftp.quit()