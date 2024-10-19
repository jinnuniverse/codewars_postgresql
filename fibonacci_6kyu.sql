CREATE OR REPLACE FUNCTION fibo_array(
    out arr_res bigint[],
    out arr_id integer[]
) as
$$
declare
  i bigint;
  n_max int;
begin

  select max(n) into n_max from fibo;
  
  for i in 1..n_max loop
    
    arr_id[i] := i;
    
    if i = 1 then 
      arr_res[i] := 0;
    end if;
    
    if i = 2 or i = 3 then 
      arr_res[i] := 1;
    end if;
    
    if i > 3 then
      arr_res[i] := arr_res[i - 1] + arr_res[i - 2];
    end if;
    
  end loop;
  
end;
$$ LANGUAGE plpgsql;

with array_cte as (
  select
    unnest(arr_res) AS res,
    unnest(arr_id) AS id
  from fibo_array()
)

select distinct u.id as n, u.res from array_cte u
  inner join fibo t on t.n = u.id
order by u.id