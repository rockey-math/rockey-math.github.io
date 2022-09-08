// https://discourse.processing.org/t/vertex-color-interpolation-on-shape/17614/2
function voronoiSphere() {
  beginShape(TRIANGLE);
        for (int i=0; i<vr.size(); i++) {
          Rib r = vr.get(i);
          PVector v1 = faces.get(r.tr[0]).cc;
          PVector v2 = faces.get(r.tr[1]).cc;
          fill(c1);
          vertex(vxs.x, vxs.y, vxs.z);
          if (faces.get(r.tr[0]).pid!=pid) {
            fill(c2);
          } else {
            fill(c1);
          }
          vertex(s*v1.x, s*v1.y, s*v1.z);
           if (faces.get(r.tr[1]).pid!=pid) {
            fill(c2);
          } else {
            fill(c1);
          }
          vertex(s*v2.x, s*v2.y, s*v2.z);
        }
        endShape(CLOSE);
}

</script>
</body>
</html> 
