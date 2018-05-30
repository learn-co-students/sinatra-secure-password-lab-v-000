def solve(a)
    # split array into two arrays, with element at index 1 as the delimiter
    # iterates through array until the sums in both arrays are equal
    # return the delimiter

   divider = a.any? do |number|
        array_1 = a.take(a.index(number))
        array_2 = a.drop(a.index(number))
        array_2.shift
        array_1 = [0] if array_1.empty?
        array_2 = [0] if array_2.empty?
        array_1.reduce(:+) == array_2.reduce(:+)
    end

    divider ? "YES" : "NO"
end

numbers = %w(31 59 49 55 48 46 47 33 47 25 49 34 52 35 46 55 44 53 56 34 38 36 41 49 55 38 42 20 22 33 43 51 28 44 45 25 19 19 18 32 27 33 15 13 29 29 30 18 27 12 15 19 14 28 18 22 26 18 28 21 27 23 24 17 32 21 30 34 27 15 30 31 31 14 19 26 18 15 29 23 16 12 31 23 30 17 31 20 32 28 23 29 18 27 31 16 12 15 28 28).map(&:to_i)
solve(numbers)
