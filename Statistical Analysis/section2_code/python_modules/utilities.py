def is_black(value):
    try:
        if(int(value)==0):
            return False
        else:
            return True
    except:
        return True
def is_inbound(pixel,shape):
    x,y=pixel
    rows,columns=shape
    if(x in range(rows)):
        if(y in range(columns)):
            return True
    return False

def find_neighbours(pixel,shape):
    x,y=pixel
    result =list()

    neighbour=(x-1,y-1)
    if(is_inbound(neighbour,shape)):
        result.append(neighbour)
    neighbour=(x-1,y)
    if(is_inbound(neighbour,shape)):
        result.append(neighbour)
    neighbour=(x-1,y+1)
    if(is_inbound(neighbour,shape)):
        result.append(neighbour)
    neighbour=(x,y-1)
    if(is_inbound(neighbour,shape)):
        result.append(neighbour)
    neighbour=(x,y+1)
    if(is_inbound(neighbour,shape)):
        result.append(neighbour)
    neighbour=(x+1,y-1)
    if(is_inbound(neighbour,shape)):
        result.append(neighbour)
    neighbour=(x+1,y)
    if(is_inbound(neighbour,shape)):
        result.append(neighbour)
    neighbour=(x+1,y+1)
    if(is_inbound(neighbour,shape)):
        result.append(neighbour)

    return result

def find_same_neighbours(pixel,image_data):
    result=list()
    x,y=pixel
    black=is_black(image_data[x][y])

    neighbours=find_neighbours(pixel,image_data.shape)
    for neighbour in neighbours:
        i,j=neighbour
        if(black==is_black( image_data[i][j])):
            result.append(neighbour)
    
    return result

