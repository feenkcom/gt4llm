Extension { #name : #ProtoObject }

{ #category : #'*Gt4LlmCore' }
ProtoObject >> llmDataViewsInContext: aContext [
	"This collects all data views for the current object.
	By default, it simply looks for the #gtLlmDataView pragma.
	The caller can decice whether or not adata  view is needed.
	Subclasses might want to override it for more special behavior.
	aContext is used to pass relevant data"
	
	^ GtLDataViewsCollector new
		fromObject: self;
		context: aContext;
		collect.
]
