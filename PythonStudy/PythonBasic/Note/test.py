data = [[1,2,3],[4,5,6],[7,8,9]]


for i in range(1,6):
    print("*" * i)

for i in range(1,6):
    for j in range(i):
        print("*", end ='')
    print()

for i in range(1,6):
    for j in range(6-i):
        print(" ", end ='')
    for j in range(i):
        print("*", end="")
    print()