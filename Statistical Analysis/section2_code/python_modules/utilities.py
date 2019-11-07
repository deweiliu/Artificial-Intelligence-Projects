import numpy

def is_black(pixel,image_data):

    try:
        x,y=pixel
        value=image_data[x][y]
    except:
        # x or y is out of index
        # consider it as a white pixel
        return False
    
    try:

        # if the value is 0
        if(int(value)==0):

            # white pixel
            return False
        else:

            # otherwise, black
            return True
    except:
        # value is not an integer, consider it as a black pixel
        return True

def is_inbound(pixel,shape):
    x,y=pixel
    rows,columns=shape
    if(x in range(rows)):
        if(y in range(columns)):
            return True
    return False

def find_neighbours(pixel):
    x,y=pixel
    result =list()

    neighbour=(x-1,y-1)
    result.append(neighbour)

    neighbour=(x-1,y)    
    result.append(neighbour)

    neighbour=(x-1,y+1)
    result.append(neighbour)
    
    neighbour=(x,y-1)
    result.append(neighbour)

    neighbour=(x,y+1)
    result.append(neighbour)

    neighbour=(x+1,y-1)
    result.append(neighbour)

    neighbour=(x+1,y)
    result.append(neighbour)

    neighbour=(x+1,y+1)
    result.append(neighbour)

    return result

def find_same_neighbours(pixel,image_data):
    result=list()
    black=is_black(pixel,image_data)

    neighbours=find_neighbours(pixel)
    for neighbour in neighbours:
        if(black==is_black(neighbour, image_data)):
            result.append(neighbour)
    
    return result

def get_tile(pixel,n,image_data):
    result=list()
    x,y=pixel
    for each_row in range(x,x+n):
        for each_column in range(y,y+n):
            if(is_black((each_row,each_column),image_data)):
                result.append('1')
            else:
                result.append('0')
    result=numpy.array(result)
    
    return result.reshape(n,n)