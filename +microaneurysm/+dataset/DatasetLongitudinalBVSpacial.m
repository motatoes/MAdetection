classdef DatasetLongitudinalBVSpacial < microaneurysm.dataset.DatasetLongitudinalBV
    
    properties
        all_images
        left_registration_pairs
        right_registration_pairs
    end

% A list of all the images listed here 1-line for each patient for readability    
%                '1/ae33cf99-afed-4d61-9cc8-aa7d30f98ff4_20130809 160229_UU.jpg', '1/5d3df61e-bc68-47c8-953f-1212c99a4b96_20130809 160236_UU.jpg', '1/a22c9d81-55db-4c05-bd41-382e6fb59ce0_20130809 160243_UU.jpg', '1/616ae808-4b30-4486-bc70-6bc0f64cb57f_20130809 160224_UU.jpg', 
%                '3/5c2058b7-8e80-4148-b925-54078f00393f_20130729 143948_UU.jpg', '3/7d93d5b6-5607-4c65-a6d7-7281f6151a1b_20130729 143914_UU.jpg', '3/e74c7b2a-1ae7-401f-99bc-fd59749d2d22_20130729 144007_UU.jpg', '3/38c1720b-7a09-4806-b226-c242b8f2d7fd_20130729 144020_UU.jpg', 
%                '4/5b6f73fa-245d-4ce0-a5c9-8dbfe4efea80_20130703 140546_UU.jpg', '4/eb213129-7bd3-4d07-af36-ee44c67b06d6_20130703 140642_UU.jpg', '4/0cdc9a0b-1d5b-403c-ba9d-04ae56e2f8ee_20130703 140620_UU.jpg', '4/a2fb87a7-a1d8-4962-9c8f-070af2cc702d_20130703 140655_UU.jpg', 
%                '5/353925b6-3990-45a7-8b85-d9f80cb1ac88_20131017 112221_UU.jpg', '5/e5186735-c091-42da-83d5-5a29f5ee0cda_20131017 112202_UU.jpg', '5/991e9180-6396-4c47-a49a-1190516db48a_20131017 112229_UU.jpg', '5/bda55489-d595-4f5f-944d-6967e665f36d_20131017 112150_UU.jpg', 
%                '6/ca8df4d6-57d1-4a09-943f-e93d6852ee82_20131002 110948_UU.jpg', '6/07c9a3ff-cb20-465a-ba28-215b85d07660_20131002 110852_UU.jpg', '6/e2558fb7-b182-49f4-b996-ed6ea2845e7f_20131002 110934_UU.jpg', '6/b1be8e87-9d17-4891-8664-18fbfdc17b04_20131002 110901_UU.jpg', 
%                '7/c39b4410-2c1a-41ed-a769-62a6a45755ef_20131101 134757_UU.jpeg', '7/4da529c7-9c5a-4c1c-a487-9e006fad31c0_20131101 134817_UU.jpeg', '7/54b31773-f216-49e1-96fc-8a663949b320_20131101 134802_UU.jpeg', '7/86b2a9e3-79c5-4c1f-ab91-01472f7ef4f5_20131101 134826_UU.jpeg', 
%                '8/7ce21c46-89f4-475d-ae41-bca407a2fe7a_20130918 110914_UU.jpg', '8/016ca500-93ec-47a7-98aa-49e34496c673_20130918 110948_UU.jpg', '8/d7d68b2c-e9aa-4a3e-b167-e6270afa3d15_20130918 110936_UU.jpg', '8/9cd5a365-e2ad-480e-8044-4d51bf46e705_20130918 110920_UU.jpg', 
%                '9/b17ac12e-d3e9-44a8-b17c-8f2a37938c2a_20130924 101936_UU.jpg', '9/872991fc-8507-4e89-98ee-85d47aea95d2_20130924 101950_UU.jpg', '9/bfcb02d9-65f4-4325-a383-559c713078fe_20130924 102013_UU.jpg', '9/390271a2-6e55-40b3-a71b-59e5ed899757_20130924 102001_UU.jpg', 
%                '10/38906620-a0a3-4012-b022-ab0586579a4d_20131023 110621_UU.jpg', '10/4b6672fa-da5e-44b5-9215-c70c4886b7f3_20131023 110558_UU.jpg', '10/d2779679-8b0b-4fa9-b065-2e1174afb034_20131023 110541_UU.jpg', '10/d0baf10b-649f-4768-a963-992e0ff54708_20131023 110637_UU.jpg', 
%                '11/341c9ebc-5b83-4635-b6bc-d49c993b83fd_20130710 154524_UU.jpeg', '11/1813f569-14e1-4757-b421-fd37e2f52335_20130710 154615_UU.jpeg', '11/6c436e9a-f093-4c25-b2b9-ae31597023de_20130710 154537_UU.jpeg', '11/4ba1352a-1567-41c3-b020-0f218c7bc1a7_20130710 154551_UU.jpeg', 
%                '12/68dde2d2-18c2-4671-a1ab-25f99666c410_20130723 143512_UU.jpg', '12/5b6db975-0021-473b-951a-35fdad93afff_20130723 143551_UU.jpg', '12/ced3a856-9e46-4ba9-b964-822ed12a44f0_20130723 143607_UU.jpg', '12/89fb7dd4-e5e9-4d1d-90f3-2d09bc3b596d_20130723 143616_UU.jpg', 
%                '13/094c1e6e-78eb-446c-9954-2735bb266a14_20131016 104249_UU.jpg', '13/4e3a4c27-d96a-4b25-9649-dfe27fea4c86_20131016 104223_UU.jpg', '13/ae0103a0-5784-4c82-86be-cecdf3b15109_20131016 104301_UU.jpg', '13/d82c6108-6eeb-4a9d-8b12-4eeb1389201f_20131016 104232_UU.jpg', 
%                '14/12f24060-8689-4b0d-913d-20b9774f87b7_20130920 154803_UU.jpg', '14/32c041c3-0683-4844-935a-c2ca29753309_20130920 154749_UU.jpg', '14/568125bc-5c5f-4fef-80ce-20440cf59086_20130920 154809_UU.jpg', '14/91ec5bbf-deaa-4deb-9ec6-10e8b723adc1_20130920 154754_UU.jpg', 
%                '15/fea8d972-bd10-40b9-b390-1c0ba530ce91_20130717 152510_UU.jpg', '15/785185b3-ea58-4447-9fd6-58e2b3dcb4d1_20130717 152425_UU.jpg', '15/b9fae3d4-8f6c-4405-a9dd-6013919553fe_20130717 152405_UU.jpg', '15/6fd9e532-c6da-4c2b-b3dc-b56616a75216_20130717 152442_UU.jpg', 
%                '16/c069c26c-0cd0-405a-982d-871c70b3c974_20130828 140218_UU.jpeg', '16/a6c04274-97a5-492a-8a2c-6ff3d2fba23d_20130828 140233_UU.jpeg', '16/3dff122e-4e07-4b1b-b541-56044a311747_20130828 140210_UU.jpeg', '16/dc574aa7-e1a0-48b5-8d07-8c729e33bdee_20130828 140242_UU.jpeg', 
%                '17/dea6f5e4-ea8b-4f10-afda-03d8e5feabd2_20130729 145009_UU.jpeg', '17/fd49eb3c-81d5-4dba-ad58-9224178abb7e_20130729 145039_UU.jpeg', '17/abad3b94-e976-4e54-93cd-b9521a558ff3_20130729 145026_UU.jpeg', '17/dcee0a0b-fa8a-4780-a8ba-d8df3758b4ce_20130729 144958_UU.jpeg', 
%                '18/86774ae0-2c3e-4b27-91a2-e0652c84b60a_20130920 111040_UU.jpg', '18/a0b032c5-d172-4e0a-b32f-7295f3f6e124_20130920 111146_UU.jpg', '18/2be03e05-f2fe-476a-9eb2-78e7c6b591cc_20130920 111132_UU.jpg', '18/ae96afbf-370e-4a9e-ba85-f4cb9e966c7f_20130920 111054_UU.jpg', 
%                '19/88c31da0-8034-4ba8-b4b8-ef5d43724507_20130923 135708_UU.jpg', '19/210295be-0e9e-4894-92bb-4042b65d41a0_20130923 135739_UU.jpg', '19/74bf8d87-c5e0-48c6-bf50-6133c896fda4_20130923 135654_UU.jpg', '19/c7bd0c93-07c2-4ba9-bcf8-66fe9f62cc08_20130923 135727_UU.jpg', 
%                '20/caadc64c-b501-4bdd-b4b9-c2d76477cfb4_20130812 155214_UU.jpeg', '20/8d3164f2-c4ed-40da-8d70-f31babf259f9_20130812 155250_UU.jpeg', '20/32676be9-9a7b-41a9-a7f1-61ac024ea2f8_20130812 155305_UU.jpeg', '20/b648df29-9caf-4f95-b633-ae21fcd62a8e_20130812 155229_UU.jpeg', 
%                '21/d5542cc2-8066-4cfa-b630-d3caccb5aef4_20130910 100523_UU.jpg', '21/19d03bb0-372b-4eb9-9718-75796f3ec28c_20130910 100537_UU.jpg', '21/42be6f81-8a2b-42d6-add5-e043b16bf7df_20130910 100528_UU.jpg', '21/7792ce30-2c13-4641-a777-6c694fdc927d_20130910 100542_UU.jpg'
%                '22/44512fae-ef6f-4516-8bfe-27f0563405b8_20130704 103540_UU.jpg', '22/6695c939-1f95-43e6-b044-a2040b67fa6f_20130704 103604_UU.jpg', '22/8533480d-65ab-443f-a194-71b010831cfb_20130704 103528_UU.jpg', '22/3233593e-3704-4cc5-98d5-38ed5cda64a8_20130704 103613_UU.jpg', 
%                '23/66e94c58-63c4-4687-8a5c-1706a8af673f_20130822 095115_UU.jpg', '23/1630af70-fbb9-4da8-bb6d-d4ec2a87e8d7_20130822 095205_UU.jpg', '23/6adf63b3-e437-438e-8149-938ac98929c4_20130822 095016_UU.jpg', '23/8e186a21-83dd-48bf-9d9e-dd1aa6ebf317_20130822 095219_UU.jpg', 
%                '24/4d8f14c2-b70e-4f68-93d8-cdc7c42eb7a5_20130827 102714_UU.jpg', '24/2100dbd2-7855-4cb0-8811-a76e53e64051_20130827 102639_UU.jpg', '24/12ac3a0e-4200-4b09-8e0a-4539e4e931a2_20130827 102657_UU.jpg', '24/42474f04-cb98-4036-8e11-ed7d341d66c2_20130827 102626_UU.jpg', 
%                '25/98df430f-da1c-4da1-9989-d62ac633318a_20130701 095251_UU.jpeg', '25/310ce710-e923-45c1-b3d5-a47cab4b2232_20130701 095300_UU.jpeg', '25/4e24cc35-4eef-404c-a6e0-19d71e13c0b9_20130701 095338_UU.jpeg', '25/9cbee6f2-7442-427b-8bc2-07c2e287cd7e_20130701 095324_UU.jpeg', 
%                '26/9292bf06-5d64-4117-95de-4240b149903d_20130806 161241_UU.jpg', '26/a074d888-13ab-4cbf-85df-f2825fb0017f_20130806 161218_UU.jpg', '26/fbbdc3a1-31f3-48d6-82fa-4eafce8889e0_20130806 161301_UU.jpg', '26/824110ce-0ead-4c36-820d-bf400e465057_20130806 161229_UU.jpg', 
%                '27/8cc1f334-9fea-4fe0-828c-f307fddc1bd4_20131004 103520_UU.jpg', '27/339b0682-9539-40b1-adbe-2aa53cc3f9c3_20131004 103353_UU.jpg', '27/d6beffae-acf3-416b-aa7b-f39f1a80ac26_20131004 103427_UU.jpg', '27/19604ee6-c7ca-42ea-b29d-74f7df3bff27_20131004 103452_UU.jpg', 
%                '28/ff2cb3b1-fc71-4f2e-adce-2297a343fb10_20131014 170302_UU.jpg', '28/0bd07174-9060-4c1c-82fa-6de9ba647163_20131014 170312_UU.jpg', '28/06336044-d15e-409e-9bdd-59306e4a5ef7_20131014 170315_UU.jpg', '28/e18b5dfd-3d97-4597-b355-865e15b43724_20131014 170307_UU.jpg', 
%                '29/3782ead2-eb41-4df0-9bbf-c491d186d882_20130814 141509_UU.jpeg', '29/1a162f71-312b-4022-a003-9a8a546f5816_20130814 141628_UU.jpeg', '29/7beefcab-e190-440f-b19a-b1356d84ca6f_20130814 141537_UU.jpeg', '29/5e5edd46-9764-4715-921c-911c495f5570_20130814 141710_UU.jpeg', 
%                '30/271c833f-3aed-42ac-b90c-76d2d7bd1f7c_20130912 164817_UU.jpeg', '30/6d472bc4-504d-462e-8e86-2305a3055c78_20130912 164735_UU.jpeg', '30/46fd1015-8622-4280-bfae-256015716d8f_20130912 164748_UU.jpeg', '30/b759091f-e277-4586-b3b7-34b787c68ba4_20130912 164804_UU.jpeg', 
%                '31/c9721a15-fb8c-49aa-83ee-570d6ed92845_20130912 112933_UU.jpeg', '31/614f62b2-0dd0-4e5d-be1f-b5286a775297_20130912 112911_UU.jpeg', '31/f6bf05b8-925e-48c8-a141-f1b198ad9d83_20130912 112952_UU.jpeg', '31/99ffcfc2-2ccc-4c5c-a9ad-aab182bee2fc_20130912 113002_UU.jpeg', 
%                '33/2c20347e-93a2-415d-a106-0c55301a9b94_20130905 121608_UU.jpg', '33/8068717f-08f5-4f8f-9bec-0e627c2ede91_20130905 121631_UU.jpg', '33/5f6e5c5e-bbb1-4f4a-8eeb-6ce0f158fad7_20130905 121614_UU.jpg', '33/0d54987f-2c64-49f9-920d-6c2aa10ab4ac_20130905 121626_UU.jpg', 
%                '34/4c2069a5-42d2-4c9f-beab-259d5183499c_20131014 122856_UU.jpg', '34/2330a6f7-ab42-45f5-be20-6643e3d07f74_20131014 122912_UU.jpg', '34/fdbb3a21-4452-4f30-93e6-54aeae849ce8_20131014 122851_UU.jpg', '34/b6d026d0-48a1-40da-92f4-1f4a0144852d_20131014 122906_UU.jpg', 
%                '35/0b468ff7-09cc-4f92-9103-4cc2f94681f9_20130802 103827_UU.jpg', '35/69a3efb9-d9ba-4e03-8435-698de3fb4d8b_20130802 103842_UU.jpg', '35/feaad6ce-6c2c-4822-bf56-22f05132556e_20130802 103757_UU.jpg', '35/740fa29f-1512-40e7-99ac-d0335d945dc5_20130802 103730_UU.jpg', 
%                '36/1c850b47-e536-42c3-a2e8-222f23feaea6_20131018 163737_UU.jpg', '36/d1227d0d-ad79-45b1-8c48-2d51002b4d76_20131018 163825_UU.jpg', '36/471d4153-9f4d-4e82-b670-03e0006a8314_20131018 163831_UU.jpg', '36/71c32b4a-af85-4ea3-b52b-f10630d7ecaa_20131018 163807_UU.jpg', 
%                '37/c69d4282-7136-42b5-87e8-cf9af0627960_20130911 161122_UU.jpg', '37/e35936e3-53e3-4e27-8ee9-4f4f4306b424_20130911 160917_UU.jpg', '37/911e3266-d240-45f5-bbb9-d836c781f20e_20130911 161025_UU.jpg', '37/be761050-86a4-4df9-89bc-09fcf02b1e24_20130911 161057_UU.jpg', 
%                '38/a25a4e7d-4a2f-407e-afce-80db572c7651_20131101 112013_UU.jpeg', '38/be4a41a0-c786-48fd-9853-cbc525ada4b2_20131101 112021_UU.jpeg', '38/0aa08067-9f84-4303-b6e5-3f14b2d3a0c0_20131101 112027_UU.jpeg', '38/032fde08-cd03-44db-950a-e617c4df3229_20131101 112008_UU.jpeg', 
%                '39/ec642ee2-47ad-46a7-941f-729b8f07e404_20130822 154838_UU.jpg', '39/6b1200e0-5f25-4413-b559-f9b83ee870c4_20130822 154829_UU.jpg', '39/60d566e2-179d-424e-830d-8c15845e1cdb_20130822 154807_UU.jpg', '39/3d4086f8-51ca-403e-8536-e085c7fd02cd_20130822 154816_UU.jpg', 
%                '40/ec19e719-d0c9-45b2-87be-7f1007d4927f_20130725 155951_UU.jpg', '40/2ef9ec02-a512-479b-96ff-4a9b443babf8_20130725 155844_UU.jpg', '40/45181b1e-d563-4843-a096-87089f72f711_20130725 155908_UU.jpg', '40/9079249b-6f19-4ed5-9831-6bb137418f9e_20130725 155935_UU.jpg', 
%                '41/f1e2baae-9922-4313-9d00-ac2133e54366_20130926 151253_UU.jpg', '41/37d04333-4de8-461d-be6f-1d8eb604f799_20130926 151328_UU.jpg', '41/8f3264b0-8312-442b-8fac-58ef36b5d1f0_20130926 151318_UU.jpg', '41/de70c2ea-8432-4eb0-bdbf-78b73506b23c_20130926 151303_UU.jpg', '42/60dc6e16-d44c-4cca-9333-bd5b49e44f0f_20130715 150300_UU.jpeg', '42/e52a77df-50ea-4948-b254-11fec9ab48ed_20130715 150307_UU.jpeg', '42/f57a92fd-6471-4372-a4c3-36770d5ca6f6_20130715 150325_UU.jpeg', '42/38a7c067-390b-4694-84ea-1fc003d76563_20130715 150317_UU.jpeg'
%                '42/60dc6e16-d44c-4cca-9333-bd5b49e44f0f_20130715 150300_UU.jpeg', '42/e52a77df-50ea-4948-b254-11fec9ab48ed_20130715 150307_UU.jpeg', '42/f57a92fd-6471-4372-a4c3-36770d5ca6f6_20130715 150325_UU.jpeg', '42/38a7c067-390b-4694-84ea-1fc003d76563_20130715 150317_UU.jpeg'};
    
    methods
        function obj = DatasetLongitudinalBVSpacial(varargin)
           obj = obj@microaneurysm.dataset.DatasetLongitudinalBV(varargin{:});
          
           obj.all_images = [ obj.training_files, obj.test_files];

           obj.left_registration_pairs = [
                3, 2; % 1/
                4, 3; % 3/
                4, 2; % 4/
                3, 1; % 5/
                1, 3; % 6/
                4, 2; % 7/
                2, 3; % 8/
                3, 4; % 9/
                4, 1; % 10/
                2, 4; % 11/
                4, 3; % 12/
                3, 1; % 13/
                3, 1; % 14/
                1, 4; % 15/
                4, 2; % 16/
                2, 3; % 17/
                2, 3; % 18/
                2, 4; % 19/
                3, 2; % 20/
                2, 4; % 21/
                4, 2; % 22/
                4, 2; % 23/
                1, 3; % 24/
                3, 4; % 25/
                3, 1; % 26/
                1, 4; % 27/
                3, 2; % 28/
                4, 2; % 29/
                1, 4; % 30/
                4, 3; % 31/
                2, 4; % 33/
                2, 4; % 34/
                2, 1; % 35/
                3, 2; % 36/
                1, 4; % 37/
                3, 2; % 38/
                1, 2; % 39/
                1, 4; % 40/
                2, 3; % 41/
                3, 4; % 42/
           ];

           obj.right_registration_pairs = [
                1, 4; % 1/
                1, 2; % 3/
                3 ,1; % 4/
                2, 4; % 5/
                4, 2; % 6/
                3, 1; % 7/
                4, 1; % 8/
                2, 1; % 9/
                2, 3; % 10/
                3, 1; % 11/
                2, 1; % 12/
                4, 2; % 13/
                4, 2; % 14/
                2, 3; % 15/
                1, 3; % 16/
                1, 4; % 17/
                4, 1; % 18/
                1, 3; % 19/
                4, 1; % 20/
                3, 1; % 21/
                1, 3; % 22/
                1, 3; % 23/
                2, 4; % 24/
                2, 1; % 25/
                4, 2; % 26/
                3, 2; % 27/
                4, 1; % 28/
                3, 1; % 29/
                3, 2; % 30/
                1, 2; % 31/
                3, 1; % 33/
                1, 3; % 34/
                3, 4; % 35/
                4, 1; % 36/
                3, 2; % 37/
                1, 4; % 38/
                4, 3; % 39/
                3, 2; % 40/
                4, 1; % 41/
                2, 1; % 42/                
           ];
       
           % In order to commpare both training and test files together we
           % need to have a set of images in the training set that
           % contains both of the views .. This makes it possible to
           % compare it with the results from the multi-view registration
           % techniques as well
           
        end
        
        function pair = getImagePairNames(self, offsets, idx)
            offset1 = offsets(idx,1);
            offset2 = offsets(idx,2);
            
            im1 = self.all_images{ (idx-1) * 4 + offset1};
            im2 = self.all_images{ (idx-1) * 4 + offset2};
            
            pair = {im1, im2};
            
        end
        
        function pair = getLeftImagePairNames(self, idx)
            pair = self.getImagePairNames(self.left_registration_pairs, idx);
        end

        function pair = getRightImagePairNames(self, idx)
            pair = self.getImagePairNames(self.right_registration_pairs, idx);
        end
        
        function res = register_image_pair(self, image1, image2, image1Points, image2Points)
            Registration.register(image1, image2, image1Points, image2Points);
        end
        
        function res = register_right_image_pair(idx, image1Points, image2Points)
            imagePairNames = self.getRightImagePairNames(idx);
            self.register_image_pair(imagePairNames(1), imagePairNames(2), image1Points, image2Points);
        end
        
        function res = register_left_image_pair(idx, image1Points, image2Points)
            imagePairNames = self.getLeftImagePairNames(idx);
            self.register_image_pair(imagePairNames(1), imagePairNames(2), image1Points, image2Points);
        end
                
    end
    
end

