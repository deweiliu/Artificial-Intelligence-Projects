import math
import numpy

def is_black(pixel,image_data):

    try:
        x,y=pixel
        value=image_data[x][y]
    except IndexError:
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
        print('Warnning: pixel value is not an integer')
        # value is not an integer, consider it as a black pixel
        return True

def is_inbound(pixel,shape):
    x,y=pixel
    rows,columns=shape
    if(x in range(rows)):
        if(y in range(columns)):
            return True
    return False


def find_contacted_neighbours(pixel):
    """
    It returns 4 pixels that are at the top, bottom, left and right of the variable pixel
    """
    x,y=pixel
    result =list()
    neighbour=(x-1,y)    
    result.append(neighbour)    
    neighbour=(x,y-1)
    result.append(neighbour)
    neighbour=(x,y+1)
    result.append(neighbour)
    neighbour=(x+1,y)
    result.append(neighbour)

    return result


def find_neighbours(pixel):
    x,y=pixel
    result =find_contacted_neighbours(pixel)

    neighbour=(x-1,y-1)
    result.append(neighbour)

    neighbour=(x-1,y+1)
    result.append(neighbour)

    neighbour=(x+1,y-1)
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
def find_whites(image_data):
    result=list()
    rows,columns=image_data.shape
    for each_row in range(rows):
        for each_column in range(columns):
            pixel=(each_row,each_column)
            if(not is_black(pixel,image_data)):
                result.append(pixel)
    return result
def find_blacks(image_data):
    result=list()
    rows,columns=image_data.shape
    for each_row in range(rows):
        for each_column in range(columns):
            pixel=(each_row,each_column)
            if(is_black(pixel,image_data)):
                result.append(pixel)
    return result
def move_element(source_array,elemment_index,destination_array):
    
    element=source_array.pop(elemment_index)
    destination_array.append(element)

def cluster_neighbour_pixels(pixel_list,contacted_neighbours_only=False):
    """
    
    This method taks a list of pixels and cluster/group them
    By 'cluster', it means put the pixels in different clusters, so that any two pixel in a cluster are connected
    by 'connected', it means "Two black pixels A and B are connected if they are neighbours of each other,
     or if a black pixel neighbour of A is connected to B (this definition is actually symmetric);
      a connected region is a maximal set of black pixels which are connected to each other"  (Reference from CSC3060 assignment2.pdf)
    
    By 'contacted_neighbours', please see the definition is the method 'find_contacted_neighbours()' in the python module

    This method returns a list of clusters, each cluster is a list of pixels
    """
    result=list()
    
    # to protect the original list
    pixel_list=pixel_list.copy()
    while(len(pixel_list)>0):
        
        # Create a new cluster with the new pixel
        cluster=list()
        move_element(pixel_list,0,cluster)
        
        # The pixel I need to search for. By 'search for', it means to check its neighbours are in the same cluster
        cluster_pointer=0

        # If I have not searched the whole cluster
        while(cluster_pointer<len(cluster)):
            
            # find out all neighbours which are in the 'pixel_list'
            current_pixel=cluster[cluster_pointer]
            if(contacted_neighbours_only):
                neighbours=find_contacted_neighbours(current_pixel)
            else:
                neighbours=find_neighbours(current_pixel)
            for neighbour in neighbours:
                try:
                    # if the neighbouring pixel is in the pixel_list
                    index=pixel_list.index(neighbour)

                    # move it to the cluster
                    move_element(pixel_list,index,cluster)
                except ValueError:
                    # if it is not in the pixel_list
                    pass
            
            # Finished searching for the current pixel
            cluster_pointer+=1
        
        # Finished searching the whole cluster, add the cluster to the result
        result.append(cluster)

        # Then the top level while loop continues for the next clusster
    return result


def pixel_at_edge(pixel,shape):
    """
    returns if a pixel is at the edge of the shape
    """
    rows,columns=shape
    x,y=pixel
    if(x==0):
        return True
    if(x==rows-1):
        return True
    if(y==0):
        return True
    if(y==columns-1):
        return True

    return False
        
def euclidean_distance(pixel1,pixel2):
    x1,y1=pixel1
    x2,y2=pixel2
    x_distance=abs(x1-x2)
    y_distance=abs(y1-y2)
    
    return math.sqrt(x_distance*x_distance+y_distance*y_distance)