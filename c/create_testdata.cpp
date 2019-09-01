#include "catch.hpp"

#include "old_password.h"

#include <cstdlib>
#include <fstream>
#include <iostream>
#include <ctime>
#include <sstream>

struct Words
{
    Words()
    {
        // initialize random number generator with time
        std::srand(std::time(nullptr));
    }

    double random() const
    {
        return (double)std::rand() / (double)RAND_MAX;
    }

    std::string random_word() const
    {
        double v = random();
        int i = int(v * words.size() + 0.5);

        std::string word = words[i];

        bool capitalize = random() > 0.5;
        if (capitalize)
        {
            for (char &c : word)
            {
                c = toupper(c);
            }
        }

        std::stringstream ss;
        ss << word << std::rand();

        return ss.str();
    }

    std::string long_random_word(int number = 10) const
    {
        std::string word;

        while (number-- > 0)
        {
            word += random_word();
        }

        return word;
    }

    void write_line(const std::string &password, const std::string &hash)
    {
        out << password << ";" << hash << "\n";
    }

    std::string old_password(const std::string &password) const
    {
        char hash[17] = "";

        my_make_scrambled_password_323(hash, &password[0], password.length());

        return std::string(hash);
    }

private:
    std::vector<std::string> words = read_words();
    std::ofstream out = std::ofstream("../../testdata.csv");

    std::vector<std::string> read_words()
    {
        std::ifstream in("../words.txt");
        std::vector<std::string> words;

        std::string line;
        while (std::getline(in, line))
        {
            words.push_back(line);
        }

        return words;
    }
};

TEST_CASE_METHOD(Words, "create testdata")
{
    for (int words = 1; words <= 20; words += 2)
    {
        // list of long words
        int count = 1000;
        while (count--)
        {
            std::string password = long_random_word(words);
            std::string hash = old_password(password);

            write_line(password, hash);
        }
    }
}