def bin_search(i,j,x,a)
    flag = (i+j)/2
    y = a[flag]
    if y == x
        y
    elsif y > x
        bin_search(i,flag,x,a)
    elsif y < x
        bin_search(flag,j,x,a)
    end
end
def select_sort(a)
    n = 1
    for number in a
        i = 0
        max = 0
        for number in a
            max = i if a[i] > a[max]
            i = i+1
            break if i > a.length-n
        end
        temp = a[a.length-n]
        a[a.length-n] = a[max]
        a[max] = temp
        n = n+1
    end
end
a = (1..100).to_a
a.shuffle!
select_sort(a)
puts a