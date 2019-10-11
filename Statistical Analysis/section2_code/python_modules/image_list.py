import os
def image_list(configuration):    
    images=dict()
    stduent=str(configuration["student_number"])
    for each_object in configuration["objects"]:

        image_list=list()
        images[each_object]=image_list

        for index in range(configuration["min_index"],configuration["max_index"]+1):
            index="{0:0=2d}".format(index)
            image="_".join([stduent,each_object,str(index)])
            image+=".csv"
            image=os.path.join(configuration["image_directory"],image)

            if(os.path.exists(image)):
                image_list.append(image)
            else:
                raise Exception("File %s does not exist."%(image))
                


    return images