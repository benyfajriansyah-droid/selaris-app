INSERT INTO trips(title,country,city,po_deadline,depart_at,return_at,quota,status)
VALUES ('Tokyo September 2026','Jepang','Tokyo','2026-09-04T23:59:00+07','2026-09-05T07:00:00+07','2026-09-10T20:00:00+07',50,'open_po')
ON CONFLICT DO NOTHING;

INSERT INTO products(trip_id,name,slug,category,country,source_price,jastip_fee,handling_fee,stock,active)
SELECT id,'Onitsuka Tiger Mexico 66','onitsuka-tiger-mexico-66','Fashion','Jepang',1550000,150000,0,8,true FROM trips WHERE title='Tokyo September 2026' LIMIT 1
ON CONFLICT(slug) DO NOTHING;
INSERT INTO products(trip_id,name,slug,category,country,source_price,jastip_fee,handling_fee,stock,active)
SELECT id,'Shiro Savon EDP','shiro-savon-edp','Beauty','Jepang',525000,60000,0,12,true FROM trips WHERE title='Tokyo September 2026' LIMIT 1
ON CONFLICT(slug) DO NOTHING;
