from python_modules.utilities import *
import numpy
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
    # todo
    def __init__(self,features_dict,image_data):
        super().__init__(Span.get_feature_name(),features_dict,image_data)
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

                # if it is a black pixel
                if(Feature.parse_value(self.image_data[each_row,each_column])):
                    pixel=(each_row,each_column)

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
        return 'neigh5'

class Left2Tile(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Left2Tile.get_feature_name(),features_dict,image_data)
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
        return 'left2tile'

class Right2Tile(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Right2Tile.get_feature_name(),features_dict,image_data)
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
        return 'right2tile'

class Verticalness(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Verticalness.get_feature_name(),features_dict,image_data)
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
        return 'verticalness'

class Top2Tile(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Top2Tile.get_feature_name(),features_dict,image_data)
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
        return 'top2tile'

class Bottom2Tile(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Bottom2Tile.get_feature_name(),features_dict,image_data)
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
        return 'bottom2tile'

class Horizontalness(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Horizontalness.get_feature_name(),features_dict,image_data)
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
        return 'nr_regions'

class NrEyes(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(NrEyes.get_feature_name(),features_dict,image_data)
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
        return 'nr_eyes'

class Hollowness(Feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Hollowness.get_feature_name(),features_dict,image_data)
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
            