from python_modules.instance import Instance

class Label():
    def __init__(self,label_name,configuration,destination_file):
        self.label_name=label_name
        self.configuration=configuration
        self.destination_file=destination_file
    def get_label_dict(self):
        result=dict()
        result['label']=self.label_name
        instances=list()
        result['instances']=instances
        min_index=self.configuration['min_index']
        max_index=self.configuration['max_index']
        for index in range(min_index,max_index+1):
            instance=Instance(self.label_name,index,self.configuration,self.destination_file)
            instance_dict=instance.get_instance_dict()
            if(isinstance( instance_dict,dict)):
                instances.append(instance_dict)
            else:
                raise Exception("Expecting an object of dictionary")


        return result