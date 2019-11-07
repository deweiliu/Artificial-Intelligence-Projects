from python_modules.utilities import *
class Feature(object):
    def __init__(self,feature_name,features_dict,image_data):
        self.feature_name=feature_name
        self.features_dict=features_dict
        self.image_data=image_data
        self.rows,self.columns=self.image_data.shape

    @staticmethod
    def get_feature_name():
        raise Exception("This method must be implemented in the specific feature class")
    
    def set_value(self):
        value=self.compute_value()
        self.features_dict[self.feature_name]=value
        return value

    def compute_value(self):
        raise Exception("This method must be implemented in the specific feature class")
    @staticmethod
    def parse_value(value):
        try:
            if(int(value)==0):
                return False
            else:
                return True
        except:
            return True

class NrPix(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(NrPix.get_feature_name(),features_dict,image_data)

    def compute_value(self):
        return len(find_blacks(self.image_data))
        result=0
        for each_row in range(self.rows):
            for each_column in range(self.columns):
                if(Feature.parse_value( self.image_data[each_row][each_column])):
                    result+=1

        return result
    @staticmethod
    def get_feature_name():
        return 'nr_pix'
            

class Height(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Height.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        starting_row=-1
        ending_row=-1
        for each_row in range(self.rows):
            for each_column in range(self.columns):
                if(Feature.parse_value( self.image_data[each_row][each_column])):
                    if(starting_row==-1):
                        starting_row=each_row
                    ending_row=each_row
                    break
            
        return ending_row-starting_row
    @staticmethod
    def get_feature_name():
        return 'height'

class Width(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Width.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        starting_column=-1
        ending_column=-1
        for each_column in range(self.columns):
            for each_row in range(self.rows):
    
                if(Feature.parse_value( self.image_data[each_row][each_column])):
                    if(starting_column==-1):
                        starting_column=each_column
                    ending_column=each_column
                    break
            
        return ending_column-starting_column
    @staticmethod
    def get_feature_name():
        return 'width'

class Span(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Span.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        result=0
        max_pixel1=None
        max_pixel2=None
        black_pixels=find_blacks(self.image_data)
        

        for pixel1 in black_pixels:
            for pixel2 in black_pixels:
                distance=euclidean_distance(pixel1,pixel2)
                if(distance>=result):
                    result=distance
                    max_pixel1=pixel1
                    max_pixel2=pixel2
        return result

    @staticmethod
    def get_feature_name():
        return 'span'

class RowsWith5(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(RowsWith5.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        result=0
        for each_row in range(self.rows):
            black_pixels_in_this_row=0
            for each_column in range(self.columns):
                if(Feature.parse_value( self.image_data[each_row][each_column])):
                    black_pixels_in_this_row+=1
                    if(black_pixels_in_this_row>=5):
                        result+=1
                        break
            
        return result
    @staticmethod
    def get_feature_name():
        return 'rows_with_5'

class ColsWith5(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(ColsWith5.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        result=0
        for each_column in range(self.columns):
            black_pixels_in_this_column=0
            for each_row in range(self.rows):
    
                if(Feature.parse_value( self.image_data[each_row][each_column])):
                    black_pixels_in_this_column+=1
                    if(black_pixels_in_this_column>=5):
                        result+=1
                        break
            
        return result
    @staticmethod
    def get_feature_name():
        return 'cols_with_5'

class Neigh1(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Neigh1.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        result=0
        for each_row in range(self.rows):
            for each_column in range(self.columns):
                pixel=(each_row,each_column)

                # if it is a black pixel
                if(is_black(pixel,self.image_data)):

                    # find its neighbours which are also black
                    same_neighbours=find_same_neighbours(pixel,self.image_data)
                    
                    # if there is only one black neighbouring pixel
                    if(len(same_neighbours)==1):
                        result+=1
        return result

    @staticmethod
    def get_feature_name():
        return 'neigh1'

class Neigh5(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Neigh5.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        result=0
        for each_row in range(self.rows):
            for each_column in range(self.columns):
                pixel=(each_row,each_column)

                # if it is a black pixel
                if(is_black(pixel,self.image_data)):

                    # find its neighbours which are also black
                    same_neighbours=find_same_neighbours(pixel,self.image_data)
                    
                    # if there is only one black neighbouring pixel
                    if(len(same_neighbours)>=5):
                        result+=1
        return result

    @staticmethod
    def get_feature_name():
        return 'neigh5'

class Left2Tile(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Left2Tile.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        result=0

        # We consider the whole image is wraped in while pixels, in other words, if a pixel is out of bound, we consider it as white
        for each_row in range(-1,self.rows):
            for each_column in range(-1,self.columns):

                pixel=(each_row,each_column)

                # get the variable pixel is at the top-left of the 2-tile
                tile=get_tile(pixel,2,self.image_data)

                if(is_black((0,0),tile)):# check if the top-left pixel is black
                    if(is_black((1,0),tile)):# check if the bottom-left pixel is black
                        if(not is_black((0,1),tile)):# check if the top-right pixel is black
                            if(not is_black((1,1),tile)):# check if the bottom-right pixel is black
                                result+=1

        return result

    @staticmethod
    def get_feature_name():
        return 'left2tile'

class Right2Tile(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Right2Tile.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        result=0

        # We consider the whole image is wraped in while pixels, in other words, if a pixel is out of bound, we consider it as white
        for each_row in range(-1,self.rows):
            for each_column in range(-1,self.columns):

                pixel=(each_row,each_column)

                # get the variable pixel is at the top-left of the 2-tile
                tile=get_tile(pixel,2,self.image_data)

                if(not is_black((0,0),tile)):# check if the top-left pixel is black
                    if(not is_black((1,0),tile)):# check if the bottom-left pixel is black
                        if(is_black((0,1),tile)):# check if the top-right pixel is black
                            if( is_black((1,1),tile)):# check if the bottom-right pixel is black
                                result+=1

        return result

    @staticmethod
    def get_feature_name():
        return 'right2tile'

class Verticalness(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Verticalness.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        left2tile=self.features_dict['left2tile']
        right2tile=self.features_dict['right2tile']
        
        nr_pix=self.features_dict['nr_pix']
        return float(left2tile+right2tile)/nr_pix


    @staticmethod
    def get_feature_name():
        return 'verticalness'

class Top2Tile(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Top2Tile.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        result=0

        # We consider the whole image is wraped in while pixels, in other words, if a pixel is out of bound, we consider it as white
        for each_row in range(-1,self.rows):
            for each_column in range(-1,self.columns):

                pixel=(each_row,each_column)

                # get the variable pixel is at the top-left of the 2-tile
                tile=get_tile(pixel,2,self.image_data)

                if(is_black((0,0),tile)):# check if the top-left pixel is black
                    if(not is_black((1,0),tile)):# check if the bottom-left pixel is black
                        if(is_black((0,1),tile)):# check if the top-right pixel is black
                            if(not is_black((1,1),tile)):# check if the bottom-right pixel is black
                                result+=1

        return result

    @staticmethod
    def get_feature_name():
        return 'top2tile'

class Bottom2Tile(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Bottom2Tile.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        result=0

        # We consider the whole image is wraped in while pixels, in other words, if a pixel is out of bound, we consider it as white
        for each_row in range(-1,self.rows):
            for each_column in range(-1,self.columns):

                pixel=(each_row,each_column)

                # get the variable pixel is at the top-left of the 2-tile
                tile=get_tile(pixel,2,self.image_data)

                if(not is_black((0,0),tile)):# check if the top-left pixel is black
                    if(is_black((1,0),tile)):# check if the bottom-left pixel is black
                        if(not is_black((0,1),tile)):# check if the top-right pixel is black
                            if(is_black((1,1),tile)):# check if the bottom-right pixel is black
                                result+=1

        return result
    @staticmethod
    def get_feature_name():
        return 'bottom2tile'

class Horizontalness(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Horizontalness.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        top2tile=self.features_dict['top2tile']
        bottom2tile=self.features_dict['bottom2tile']
        
        nr_pix=self.features_dict['nr_pix']
        return float(top2tile+bottom2tile)/nr_pix


    @staticmethod
    def get_feature_name():
        return 'horizontalness'

class Feature15(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Feature15.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        starting_row=-1
        ending_row=-1
        for each_row in range(self.rows):
            for each_column in range(self.columns):
                if(Feature.parse_value( self.image_data[each_row][each_column])):
                    if(starting_row==-1):
                        starting_row=each_row
                    ending_row=each_row
                    break
            
        return ending_row-starting_row;
    @staticmethod
    def get_feature_name():
        return 'feature15'

class Feature16(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Feature16.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        starting_row=-1
        ending_row=-1
        for each_row in range(self.rows):
            for each_column in range(self.columns):
                if(Feature.parse_value( self.image_data[each_row][each_column])):
                    if(starting_row==-1):
                        starting_row=each_row
                    ending_row=each_row
                    break
            
        return ending_row-starting_row;
    @staticmethod
    def get_feature_name():
        return 'feature16'

class NrRegions(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(NrRegions.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        black_pixels=find_blacks(self.image_data)
        clusters=cluster_neighbour_pixels(black_pixels)
        return len(clusters)


    @staticmethod
    def get_feature_name():
        return 'nr_regions'

class NrEyes(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(NrEyes.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        result=0
        white_pixels=find_whites(self.image_data)
        clusters=cluster_neighbour_pixels(white_pixels,contacted_neighbours_only=True)
        for cluster in clusters:
            flag=True
            for pixel in cluster:

                # if the cluster contains white pixel which is at the edge
                if(pixel_at_edge(pixel,self.image_data.shape)):

                    # it is not an eye
                    flag=False
                    break
            # if this cluster of white pixels is an eye
            if(flag==True):
                result+=1

        return result

    @staticmethod
    def get_feature_name():
        return 'nr_eyes'

class Hollowness(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Hollowness.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        number_of_eye_pixels=0

        white_pixels=find_whites(self.image_data)
        clusters=cluster_neighbour_pixels(white_pixels,contacted_neighbours_only=True)
        for cluster in clusters:
            flag=True
            for pixel in cluster:
                if(pixel_at_edge(pixel,self.image_data.shape)):
                    flag=False
                    break
            # if this cluster of white pixels is an eye
            if(flag==True):
                number_of_eye_pixels+=len(cluster)
        
        black_pixels=        self.features_dict['nr_pix']
        return float(number_of_eye_pixels)/black_pixels  

    @staticmethod
    def get_feature_name():
        return 'hollowness'

class Feature20(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Feature20.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        starting_row=-1
        ending_row=-1
        for each_row in range(self.rows):
            for each_column in range(self.columns):
                if(Feature.parse_value( self.image_data[each_row][each_column])):
                    if(starting_row==-1):
                        starting_row=each_row
                    ending_row=each_row
                    break
            
        return ending_row-starting_row;
    @staticmethod
    def get_feature_name():
        return 'feature20'
            