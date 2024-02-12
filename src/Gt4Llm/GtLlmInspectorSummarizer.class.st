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
		views: (self summarizeViews: anObject)
]

{ #category : #accessing }
GtLlmInspectorSummarizer >> summarizeSlots: anObject [
	^ GtLlmInspectorSlotSummaryGroup
		withAll: (anObject class slots
				collect: [ :aSlot | 
					Gt4LlmInspectorSlotSummary new
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
						selector: aPragma methodSelector;
						code: aPragma method sourceCode ])
]
