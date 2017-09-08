#pragma once

#include <ios>

#ifndef BOOST_FILESYSTEM_NO_DEPERECATED
#define BOOST_FILESYSTEM_NO_DEPERECATED
#endif
#include <boost/filesystem.hpp>
#include <boost/filesystem/fstream.hpp>

#include "zarr++/io/io_base.hxx"

namespace fs = boost::filesystem;

namespace zarr {
namespace io {

    template<typename T>
    class ChunkIoZarr : public ChunkIoBase<T> {

    public:

        ChunkIoZarr() {
        }

        inline bool read(const handle::Chunk & chunk, std::vector<T> & data) const {

            // if the chunk exists, we read it,
            // otherwise, we write the fill value
            if(chunk.exists()) {

                // open input stream and read the filesize
                fs::ifstream file(chunk.path(), std::ios::binary);
                file.seekg(0, std::ios::end);
                size_t fileSize = file.tellg();
                file.seekg(0, std::ios::beg);

                // resize the data vector
                size_t vectorSize = fileSize / sizeof(T) + (fileSize % sizeof(T) == 0 ? 0 : sizeof(T));
                data.resize(vectorSize);

                // read the file
                file.read((char*) &data[0], fileSize);

                // return true, because we have read an existing chunk
                return true;

            } else {
                // return false, because the chunk does not exist
                return false;
            }
        }

        inline void write(const handle::Chunk & chunk, const std::vector<T> & data) const {
            //std::ios_base::sync_with_stdio(false);
            fs::ofstream file(chunk.path(), std::ios::binary);
            file.write((char*) &data[0], data.size() * sizeof(T));
            file.close();
        }

    };

}
}