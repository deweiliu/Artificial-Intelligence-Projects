import os 
import numpy 
from python_modules.features import *
class Instance():
    
    def __init__(self, label,index,configuration,destination_file):
        super().__init__()
        self.configuration=configuration
        self.destination_file=destination_file

        # construct the feature line text
        self.feature_line_elements=list()
        self.feature_line_elements.append(label)
        self.feature_line_elements.append(str(index))

        file_name=Instance.get_file_path(label,index,configuration)
        self.image_data=Instance.get_image_data(file_name)


        self.result =dict()
        self.result['index']=index
        self.result['features']=dict()

        self.feature_classes=list()
        self.feature_classes.append(NrPix)
        self.feature_classes.append(Height)
        self.feature_classes.append(Width)
        self.feature_classes.append(Span)
        self.feature_classes.append(RowsWith5)
        self.feature_classes.append(ColsWith5)
        self.feature_classes.append(Neigh1)
        self.feature_classes.append(Neigh5)
        self.feature_classes.append(Left2Tile)
        self.feature_classes.append(Right2Tile)
        self.feature_classes.append(Verticalness)
        self.feature_classes.append(Top2Tile)
        self.feature_classes.append(Bottom2Tile)
        self.feature_classes.append(Horizontalness)
        self.feature_classes.append(Feature15)
        self.feature_classes.append(Feature16)
        self.feature_classes.append(NrRegions)
        self.feature_classes.append(NrEyes)
        self.feature_classes.append(Hollowness)
        self.feature_classes.append(Feature20)


    def get_instance_dict(self):
        # iterate the feature names in the order in the configuration file
        for feature_name in self.configuration['features']:
            flag=False
            for feature_class in self.feature_classes:
                if(feature_name==feature_class.get_feature_name()):
                    flag=True
                    feature=feature_class(self.result['features'],self.image_data)
                    value= feature.set_value()
                    self.feature_line_elements.append(str(value))
            if(not flag):
                raise Exception("There is a feature with name '%s' found in the configuration file, but there is not corresponding class to handle this feature."%feature_name )

        self.destination_file.writelines('\t'.join(self.feature_line_elements)+'\n')


        return self.result
    @staticmethod
    def get_file_path(label,index,configuration):
        file_name=''
        file_name+=str(configuration['student_number'])
        file_name+='_'
        file_name+=label
        file_name+='_'
        file_name+="{0:0=2d}".format(index)
        file_name+='.csv'

        file_dir=configuration['image_directory']
        file_path=os.path.join(file_dir,file_name)


        return file_path
    @staticmethod
    def get_image_data(file_name):
        image_data=numpy.genfromtxt(file_name, delimiter='\t')
        return image_data