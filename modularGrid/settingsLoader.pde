class SettingsLoader {
    public int tileSize;
    public int xNumTiles;
    public int yNumTiles;
    public String templateName;
    public PImage templateImage;
    public boolean templateExists;

    SettingsLoader() {
        templateExists = false;
        // Default values:
        tileSize = 20;
        xNumTiles = 30;
        yNumTiles = 30;
        templateName = "";

        String[] settings = loadStrings("data/settings.txt");
        for(String s:settings){
            String[] setting=s.split("=");
            switch(setting[0].trim().toLowerCase()) {
                case "tilesize":
                    tileSize = Integer.valueOf(setting[1]);
                    break;
                case "xnumtiles":
                    xNumTiles = Integer.valueOf(setting[1]);
                    break;
                case "ynumtiles":
                    yNumTiles = Integer.valueOf(setting[1]);
                    break;
                case "templatename":
                    templateName = setting[1];
                    this.importTemplateImage();
                default:
                    println("No settings found");
                    break;
            }
        }
    }

    private void importTemplateImage() {
        templateImage = loadImage(templateName);
        if (templateImage == null) return;
        templateImage.loadPixels();
        if (templateImage.width == -1 || templateImage.height == -1) return;

        color threshold = #808080;
        templateImage.filter(THRESHOLD);

        xNumTiles = templateImage.width;
        yNumTiles = templateImage.height;
        templateExists = true;
    }
}
    
