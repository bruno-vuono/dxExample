global with sharing class ASI_DFPM_GanttChartElement {
	public String id { get; set; }
	public String name { get; set; }
	public Date startDate { get; set; }
	public Date endDate { get; set; }
	public String color { get; set; }
	
	public ASI_DFPM_GanttChartElement(String id, String name, Date startDate, Date endDate, String color) {
		this.id = id;
		this.name = name;
		this.startDate = startDate;
		this.endDate = endDate;
		this.color = color;
	}
}