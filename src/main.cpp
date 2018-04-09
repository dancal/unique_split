#include <iostream>
#include <stdio.h>
#include <iostream>
#include <string>
#include <stdint.h>
#include <errno.h>
#include <vector>
#include <stdlib.h>
#include <zlib.h>
#include <exception>

#include <tuple>
#include <boost/tuple/tuple.hpp>
#include <boost/foreach.hpp> 
#include <boost/unordered_map.hpp>
#include <boost/unordered_set.hpp>
#include <boost/algorithm/string/trim.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/filesystem.hpp>

using namespace std;

int main(int argc, char* argv[]) {

	if ( argc < 2 ) {
		cout << "usage : uniq_line 100 /tmp" << endl;
		return 0;
	}

	const std::string sLineLimit	= argv[1];
	const std::string sTargetPath	= argv[2];
	const int nLineLimit			= boost::lexical_cast<int>( sLineLimit );

	boost::unordered_set<std::string> mUniqDataList;
	std::string curLine;
	while ( getline( std::cin, curLine ) ) {
		if ( curLine.length() < 6 ) { continue; }

		mUniqDataList.insert( curLine );
	}

	int nIndex			= 0;
	uint64_t nLineCount	= mUniqDataList.size();
	int nFileCount		= nLineCount / nLineLimit;

	boost::filesystem::path dir( sTargetPath );
	if (boost::filesystem::create_directory(dir)) {
		// cout << "create directory : " << sTargetPath << endl;
	}

	boost::unordered_map<int, std::FILE*> mFileHandleList;
	for( int i = 0; i <= nFileCount; i++ ) {
		std::string sFileNumber	= sTargetPath + "/" + boost::lexical_cast<std::string>( i );
		mFileHandleList[i]		= std::fopen( sFileNumber.c_str(), "w");	
	}

	int nFileNumber		= 0;
	BOOST_FOREACH( const std::string &sLine, mUniqDataList ) {

		std::fprintf(mFileHandleList[nFileNumber], "%s\n", sLine.c_str());
		if ( (nIndex % nLineLimit) == nLineLimit -1 ) {
			nFileNumber++;
		}
		nIndex++;
	}

	for( int i = 0; i <= nFileCount; i++ ) {
		std::fclose( mFileHandleList[i] );
	}

	cout << mUniqDataList.size() << endl;
	//cout << "Data Line Count = " << nDataCount << ", Uniq Line Count = " << nLineCount << ", Split File Count = " << nFileCount << ", Limit Line = " << nLineLimit << endl;

	return 0;

}
