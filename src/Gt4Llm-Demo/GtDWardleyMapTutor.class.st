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
GtDWardleyMapTutor >> gtAddConnectedNodesAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Add connected nodes';
		priority: 10;
		description: 'Add new connected nodes to the provided node. Add more than one, but less than five.';
		format: 'Add connected nodes to `{1}`';
		examples: {GtLlmTutorActionExample new
					input: {'Wardley map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Packaging Design [0.70, 0.30] label [-58, 29]
component Formulation Development [0.31, 0.70] label [-86, 29]
component Manufacturing Process [0.50, 0.50] label [-78, 29]
component Raw Materials [0.10, 0.90] label [-46, 29]
component Product Distribution [0.90, 0.10] label [-74, 29]

Raw Materials->Formulation Development
Formulation Development->Manufacturing Process
Manufacturing Process->Packaging Design
Packaging Design->Product Distribution
'.
							'Action' -> 'Add connected nodes to `Manufacturing Process`'}
							asDictionary;
					output: {'Wardley map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Packaging Design [0.70, 0.30] label [-58, 29]
component Formulation Development [0.31, 0.70] label [-86, 29]
component Manufacturing Process [0.50, 0.50] label [-78, 29]
component Raw Materials [0.10, 0.90] label [-46, 29]
component Product Distribution [0.90, 0.10] label [-74, 29]
component Quality Control [0.55, 0.45] label [-60, 35]
component Equipment Maintenance [0.45, 0.55] label [-66, 25]

Raw Materials->Formulation Development
Formulation Development->Manufacturing Process
Manufacturing Process->Packaging Design
Packaging Design->Product Distribution
Manufacturing Process->Quality Control
Manufacturing Process->Equipment Maintenance
'.
							'Action' -> 'Add connected nodes'.
							'Text' -> nil.
							'Rename' -> nil} asDictionary}
]

{ #category : #'as yet unclassified' }
GtDWardleyMapTutor >> gtCreateMapAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Create map';
		priority: 1;
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
							'Text' -> nil.
							'Rename' -> nil} asDictionary}
]

{ #category : #'as yet unclassified' }
GtDWardleyMapTutor >> gtExplainAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Explain a node';
		priority: 10;
		description: 'Explains what the given node means in the context of the map in natural language. ';
		format: 'Explain the node `{1}`';
		examples: {GtLlmTutorActionExample new
					input: {'Wardley map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Market Demand [0.90, 0.10] label [-46, 29]
component Fabrication Plants [0.70, 0.30] label [-66, 29]
component Manufacturing Processes [0.50, 0.50] label [-86, 29]
component Raw Materials [0.10, 0.90] label [-46, 29]
component Design and Architecture [0.31, 0.70] label [-86, 29]

Raw Materials->Design and Architecture
Design and Architecture->Manufacturing Processes
Manufacturing Processes->Fabrication Plants
Fabrication Plants->Market Demand
'.
							'Action' -> 'Explain the node `Raw Materials` '} asDictionary;
					output: {'Wardley map' -> nil.
							'Action' -> 'Explain a node'.
							'Text'
								-> 'The node `Raw Materials` in the semiconductors Wardley map refers to the foundational and necessary resources needed to create semiconductor devices. This encompasses materials like silicon, various metals, and chemical substances that are processed and integrated into semiconductor products. Its placement on the map represents its position in the value chain and its maturity level in terms of availability and development.'.
							'Rename' -> nil} asDictionary}
]

{ #category : #'as yet unclassified' }
GtDWardleyMapTutor >> gtRenameAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Propose renames for node';
		priority: 4;
		description: 'Proposes a sensible number of alternative names for nodes (less than ten, but more than one).';
		format: 'Propose renames for node `{1}`';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Propose renames for node `Compute`'.
							'Wardley map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]'} asDictionary;
					output: {'Action' -> 'Propose renames for node'.
							'Text' -> nil.
							'Wardley map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]'.
							'Rename' -> '{''Compute'': [''Computational resources'', ''Resources'']}'}
							asDictionary.
				GtLlmTutorActionExample new
					input: {'Action' -> 'Propose renames for node `Furnace`'.
							'Wardley map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Furnace [0.9, 0.9] label [-9, 9]'} asDictionary;
					output: {'Action' -> 'Propose renames for node'.
							'Rename'
								-> '{''Furnace'': [''Boiler'', ''Heater'', ''Incinerator'', ''Kiln'', ''Stove'']}'.
							'Wardley map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Furnace [0.9, 0.9] label [-9, 9]'.
							'Text' -> nil} asDictionary}
]

{ #category : #'as yet unclassified' }
GtDWardleyMapTutor >> gtRenameFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: 'Rename';
		priority: 2;
		format: 'JSON';
		example: '```
{''Node name'': [''Proposal A'', ''Proposal B'']}
```'
]

{ #category : #'as yet unclassified' }
GtDWardleyMapTutor >> gtReviewAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Review the map';
		priority: 10;
		description: 'Review and criticize the current state of the map.';
		examples: {GtLlmTutorActionExample new
					input: {'Wardley map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Photography and Videography [0.50, 0.60] label [-102, 29]
component Editing Software [0.70, 0.40] label [-58, 29]
component Content Creation Strategy [0.20, 0.80] label [-94, 29]
component Platform Algorithms [0.31, 0.70] label [-70, 29]
component Audience Engagement [0.60, 0.50] label [-70, 29]

Content Creation Strategy->Photography and Videography
Photography and Videography->Editing Software
Editing Software->Platform Algorithms
Platform Algorithms->Audience Engagement
'.
							'Action' -> 'Review the map'} asDictionary;
					output: {'Wardley map' -> nil.
							'Action' -> 'Review the map'.
							'Text'
								-> 'The current state of the map on Instagram content creation indicates a logical flow of processes, however, several aspects could be improved for clarity and completeness:

1. **Component Placement:** Some components are clustered, such as `Platform Algorithms` and `Audience Engagement`, which may share similar labels. Distinctions or clarifications in the evolution and positioning could help better understand their specific roles and maturity in the process.

2. **Missing Intermediaries:** There may be intermediate elements or external factors that influence these processes that aren''t shown, such as marketing trends or influencer partnerships, which can significantly affect content strategies.

3. **Causal Relationships:** Consider adding feedback loops or reciprocal relationships. For instance, how `Audience Engagement` may inform or necessitate adjustments in `Content Creation Strategy` or `Platform Algorithms`.

4. **Detail Addition:** Additional details or components like `Content Distribution Channels` or `Analytics Tools` might offer a more comprehensive view of the content lifecycle and the technical environment supporting this ecosystem.

Overall, while the map covers key components, expanding it with more detailed layers and interactions could provide a fuller picture of Instagram content creation dynamics.'.
							'Rename' -> nil} asDictionary}
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
