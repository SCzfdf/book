https://www.jianshu.com/p/172b39244c85







总结

-   当key数目在10以内时，mget性能下降趋势非常小，性能基本上能达到redis实例的极限
-   当key数目在10～100之间时，mget性能下降明显，需要考虑redis性能衰减对系统吞吐的影响
-   当key数目在100以上时，mget性能下降幅度趋缓，此时redis性能已经较差，不建议使用在OLTP系统中，或者需要考虑其他手段来提升性能。

