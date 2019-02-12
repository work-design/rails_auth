//= require @antv/g2
//= require @antv/data-set

const data = [
  { genre: 'Sports', sold: 275 },
  { genre: 'Strategy', sold: 1150 },
  { genre: 'Action', sold: 120 },
  { genre: 'Shooter', sold: 350 },
  { genre: 'Other', sold: 150 },
];

const chart = new G2.Chart({
  container: 'c1',
  width: 500,
  height: 500
});

chart.source(data);
chart.scale('genre', {
  min: 0
});
chart.scale('sold', {
  range: [0, 1]
});
chart.line().position('genre*sold').color('genre');
chart.point().position('genre*sold').size(4).shape('circle').style({
  stroke: '#fff',
  lineWidth: 1
});
chart.render();
