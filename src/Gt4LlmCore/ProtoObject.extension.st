Extension { #name : #ProtoObject }

{ #category : #'*Gt4LlmCore' }
ProtoObject >> llmDataViewsFor: aDataView [
	"This is the default entry method for retrieving the wrapper view containing all views"
	^ self llmDataViewsFor: aDataView inContext: GtLDataViewContext new
]

{ #category : #'*Gt4LlmCore' }
ProtoObject >> llmDataViewsFor: aDataView inContext: aContext [
	^aDataView compositeData
		addDataViews: (self llmDataViewsInContext: aContext);
		yourself
]

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
