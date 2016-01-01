/*
	Copyright 2015 TeamWin
	This file is part of TWRP/TeamWin Recovery Project.

	TWRP is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	TWRP is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with TWRP.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef _FIXPERMISSIONS_HPP_HEADER
#define _FIXPERMISSIONS_HPP_HEADER

#include <string>
#include <sys/stat.h>
#include <vector>

using namespace std;

class fixPermissions {
	public:
		fixPermissions();
		~fixPermissions();
		int fixPerms(bool enable_debug, bool remove_data_for_missing_apps);
		int fixDataContexts();
		int fixPathContext(string path, bool recursive);

	private:
		int pchown(string fn, int puid, int pgid);
		int pchmod(string fn, mode_t mode);
		vector <string> listAllDirectories(string path);
		vector <string> listAllFiles(string path);
		void deletePackages();
		int getPackages(const string& packageFile);
		int fixApps();
		int fixAllFiles(string directory, int uid, int gid, mode_t file_perms);
		int fixDir(const string& dir, int diruid, int dirgid, mode_t dirmode, int fileuid, int filegid, mode_t filemode);
		int fixDataData(string dataDir);
#ifdef HAVE_SELINUX
		int restorecon(string entry, struct stat *sb);
		int fixContextsRecursively(string path, int level);
		int fixPathContextHandler(string path, bool recursive);
#endif

		struct package {
			string pkgName;
			string codePath;
			string appDir;
			string dDir;
			int gid;
			int uid;
			package *next;
		};
		bool debug;
		bool remove_data;
		package* head;
};

#endif // _FIXPERMISSIONS_HPP_HEADER
