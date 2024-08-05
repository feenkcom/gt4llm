Class {
	#name : #GtLlmInspectorSummarizer,
	#superclass : #Object,
	#category : #'Gt4Llm-Summarizer'
}

{ #category : #accessing }
GtLlmInspectorSummarizer >> summarize: anObject [
	^ GtLlmInspectorSummary new
		object: anObject;
		objectClass: anObject class;
		slots: (self summarizeSlots: anObject);
		methods: (self summarizeMethods: anObject);
		views: (self summarizeViews: anObject)
]

{ #category : #accessing }
GtLlmInspectorSummarizer >> summarizeMethods: anObject [
	^ GtLlmInspectorMethodSummaryGroup
		withAll: (anObject class methods
				collect: [ :aMethod | 
					GtLlmInspectorMethodSummary new
						name: aMethod selector ])
]

{ #category : #accessing }
GtLlmInspectorSummarizer >> summarizeSlots: anObject [
	^ GtLlmInspectorSlotSummaryGroup
		withAll: (anObject class slots
				collect: [ :aSlot | 
					GtLlmInspectorSlotSummary new
						slot: aSlot;
						name: aSlot name;
						slotValue: (aSlot read: anObject) ])
]

{ #category : #accessing }
GtLlmInspectorSummarizer >> summarizeViews: anObject [
	| pragmas |
	pragmas := GtPhlowViewsCollector new
			fromObject: anObject;
			context: GtPhlowContext new;
			collectPragmas.
	^ GtLlmInspectorViewSummaryGroup
		withAll: (pragmas
				collect: [ :aPragma | 
					GtLlmInspectorViewSummary new
						viewClass: aPragma methodClass;
						selector: aPragma methodSelector;
						code: aPragma method sourceCode ])
]

{ #category : #accessing }
GtLlmInspectorSummarizer >> summarizeViewsWithoutMarkup: anObject [
	| pragmas |
	pragmas := GtPhlowViewsCollector new
			fromObject: anObject;
			context: GtPhlowContext new;
			collectPragmas.
	^ GtLlmInspectorViewSummaryGroup
		withAll: (pragmas
				collect: [ :aPragma | 
					GtLlmInspectorViewSummary new
						withoutMarkup: true;
						viewClass: aPragma methodClass;
						selector: aPragma methodSelector;
						code: aPragma method sourceCode ])
]

{ #category : #accessing }
GtLlmInspectorSummarizer >> summarizeWithoutMarkup: anObject [
	^ GtLlmInspectorSummary new
		object: anObject;
		objectClass: anObject class;
		slots: (self summarizeSlots: anObject);
		methods: (self summarizeMethods: anObject);
		views: (self summarizeViewsWithoutMarkup: anObject)
]

{ #category : #accessing }
GtLlmInspectorSummarizer >> summarizeWithoutViews: anObject [
	^ GtLlmInspectorSummary new
		object: anObject;
		objectClass: anObject class;
		slots: (self summarizeSlots: anObject);
		methods: (self summarizeMethods: anObject);
		views: {}
]
