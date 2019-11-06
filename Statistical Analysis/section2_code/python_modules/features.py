class feature(object):
    def __init__(self,feature_name,features_dict,image_data):
        self.feature_name=feature_name
        self.features_dict=features_dict
        self.image_data=image_data
    @staticmethod
    def get_feature_name():
        raise Exception("This method must be implemented in the specific feature class")
    
    def set_value(self):
        self.features_dict[self.feature_name]=self.compute_value()
    def compute_value(self):
        raise Exception("This method must be implemented in the specific feature class")

class NrPix(feature):
    def __init__(self,features_dict,image_data):
        super().__init__(NrPix.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        
        return 1;
    @staticmethod
    def get_feature_name():
        return 'nr_pix'
            

class Height(feature):
    def __init__(self,features_dict,image_data):
        super().__init__(Height.get_feature_name(),features_dict,image_data)
    def compute_value(self):
        
        return 1;
    @staticmethod
    def get_feature_name():
        return 'height'
            