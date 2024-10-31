Class {
	#name : #GtDWardleyMapTutor,
	#superclass : #GtOpenAIAnnotatedActionTutor,
	#category : #'Gt4Llm-Demo'
}

{ #category : #'as yet unclassified' }
GtDWardleyMapTutor >> forObject: anObject [
	^ self valuePipelineFor: anObject withName: 'Wardley map'
]

{ #category : #'as yet unclassified' }
GtDWardleyMapTutor >> formatName [
	^ 'Wardley map'
]

{ #category : #'as yet unclassified' }
GtDWardleyMapTutor >> gtCreateMapAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Create map';
		priority: 10;
		description: 'Create a Wardley map on a given topic. Provide the result in the `Wardley Map` property.';
		format: 'Create map on {1}';
		examples: {GtLlmTutorActionExample new
					input: {'Wardley map' -> ''.
							'Action' -> 'Create map on electric vehicles'} asDictionary;
					output: {'Wardley map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Battery Technology [0.30, 0.70] label [-30, 20]
component Charging Infrastructure [0.50, 0.50] label [-50, 20]
component Software Systems [0.40, 0.60] label [-40, 40]
component Market Trends [0.20, 0.80] label [-20, 60]
component User Experience [0.60, 0.40] label [-60, 60]

Battery Technology->Software Systems
Charging Infrastructure->Battery Technology
Software Systems->User Experience
Market Trends->User Experience

'.
							'Action' -> 'Create map'.
							'Text' -> nil} asDictionary}
]

{ #category : #'as yet unclassified' }
GtDWardleyMapTutor >> gtWardleyMapFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
	type: ((OrderedCollection new) add: 'string'; add: 'null'; yourself);
	format: 'Wardley Map language';
	name: 'Wardley map';
	priority: 10;
	example: '```
style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Hello [0.80, 0.20] label [-14, 29]

component Goodbye [0.40, 0.60] label [-22, 29]

component Hello again! [0.60, 0.80] label [-42, 29]


Hello->Goodbye
Goodbye->Hello again!
```'
]

{ #category : #'as yet unclassified' }
GtDWardleyMapTutor >> messageClass [
	^ GtDWardleyMapMessage
]
