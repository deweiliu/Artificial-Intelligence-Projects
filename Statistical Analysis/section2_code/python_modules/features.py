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
        self.features_dict[self.feature_name]=self.compute_value()
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

        return result;
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
            
        return ending_row-starting_row;
    @staticmethod
    def get_feature_name():
        return 'height'
            