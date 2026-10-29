package aed;
import java.util.ArrayList;

public class InternetToolkit{

    public InternetToolkit() {
    }

    public Fragment[] tcpReorder(Fragment[] fragments) {        
        Fragment[] res = new Fragment[fragments.length];
        for(int i = 0; i < fragments.length; i++){
            res[i] = fragments[i];
            for(int j = i; j > 0; j--){
                if(res[j].compareTo(res[j-1]) < 0){
                    Fragment temp = res[j];
                    res[j] = res[j-1];
                    res[j-1] = temp;
                }else{
                    break;
                }
            }
        }
        return res;
    }

    public Router[] kTopRouters(Router[] routers, int k, int umbral) { 
        int cantRoutersQueSuperanUmbral = 0;
        for(int i = 0; i < routers.length; i++){
            if(routers[i].getTrafico() > umbral){
                cantRoutersQueSuperanUmbral++;
            }
        }
        Router[] routersQueSuperanUmbral = new Router[cantRoutersQueSuperanUmbral];
        int indiceRoutersQueSuperanUmbral = 0;
        for(int i = 0; i < routers.length; i++){
            if(routers[i].getTrafico() > umbral){
                routersQueSuperanUmbral[indiceRoutersQueSuperanUmbral] = routers[i];
                indiceRoutersQueSuperanUmbral++;
            }
        }
        HeapSort.heapify(routersQueSuperanUmbral);
        Heap heap = new Heap(routersQueSuperanUmbral);
        Router[] res = new Router[k];
        for(int i = 0; i < k && i < routersQueSuperanUmbral.length; i++){
            res[i] = heap.desencolar();
        }
        return res;
    }

    public IPv4Address[] sortIPv4(String[] ipv4) {
        IPv4Address[] direc = new IPv4Address[ipv4.length];
        ArrayList<ArrayList<IPv4Address>> buckets = new ArrayList<ArrayList<IPv4Address>>(256);
        for(int i = 0; i < ipv4.length; i++){
            direc[i] = new IPv4Address(ipv4[i]);
            buckets.add(new ArrayList<>(ipv4.length));
        }
        for(int i = 3; i >= 0; i--){
            for(int j = 0; j < direc.length; j++){
                buckets.get(direc[j].getOctet(i)).add(direc[j]);
            }
            int indiceDirec = 0;
            for(int j = 0; j < 256; j++){
                for(int k = 0; k < buckets.get(j).size(); k++){
                    direc[indiceDirec] = buckets.get(j).get(k);
                    indiceDirec++;
                }
            }
            for(int j = 0; j < buckets.size(); j++){
                buckets.get(j).clear();
            }
        }
        return direc;
    }

}
