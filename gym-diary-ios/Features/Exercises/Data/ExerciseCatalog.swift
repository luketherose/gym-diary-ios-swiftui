import Foundation

// MARK: - Data Structures
struct AttributeDef: Codable {
    let key: String
    let type: String
    let values: [String]?
    let `default`: String?
}

struct Archetype: Codable, Identifiable {
    let key: String
    let displayName: String
    let primaryGroup: String
    let primarySubgroups: [String]
    let secondarySubgroups: [String]
    let primaryMuscle: String
    let secondaryMuscles: [String]
    let allowedAttributes: [String]
    
    var id: String { key }
    
    var searchableText: String {
        let allMuscles = [primaryMuscle] + secondaryMuscles
        let allSubgroups = primarySubgroups + secondarySubgroups
        let allSearchableTerms = [displayName] + allMuscles + allSubgroups
        return allSearchableTerms.joined(separator: " ").lowercased()
    }
}

struct RuleClause: Codable {
    let scope: String
    let archetype: String?
    let target: String?
    let `if`: [String: [String]]?
    let allow: [String: [String]]?
    let deny: [String: [String]]?
    let require: [String]?
}

struct ExerciseCatalog: Codable {
    let muscleGroups: [String]
    let muscleSubgroups: [String: [String]]
    let attributes: [AttributeDef]
    let archetypes: [Archetype]
    let rules: [RuleClause]
    
    // MARK: - Singleton
    static let shared = ExerciseCatalog()
    
    private init() {
        print("🔍 ExerciseCatalog: Starting initialization...")
        
        // Test if ExerciseCatalogData is accessible
        print("🔍 ExerciseCatalog: Testing ExerciseCatalogData access...")
        let testString = ExerciseCatalogData.jsonString
        print("🔍 ExerciseCatalog: ExerciseCatalogData.jsonString length: \(testString.count)")
        
                    if testString.isEmpty {
                print("❌ ExerciseCatalog: ERROR - ExerciseCatalogData.jsonString is empty!")
                self.muscleGroups = []
                self.muscleSubgroups = [:]
                self.attributes = []
                self.archetypes = []
                self.rules = []
                return
            }
        
        // Load from hardcoded data instead of JSON file
        let jsonString = ExerciseCatalogData.jsonString
        print("🔍 ExerciseCatalog: JSON string length: \(jsonString.count)")
        
        guard let data = jsonString.data(using: .utf8) else {
            print("❌ ExerciseCatalog: Failed to convert JSON string to data")
            self.muscleGroups = []
            self.muscleSubgroups = [:]
            self.attributes = []
            self.archetypes = []
            self.rules = []
            return
        }
        
        print("✅ ExerciseCatalog: Loaded \(data.count) bytes of hardcoded JSON data")
        
                    do {
                let catalog = try JSONDecoder().decode(ExerciseCatalog.self, from: data)
                self.muscleGroups = catalog.muscleGroups
                self.muscleSubgroups = catalog.muscleSubgroups
                self.attributes = catalog.attributes
                self.archetypes = catalog.archetypes
                self.rules = catalog.rules
                print("✅ ExerciseCatalog: Loaded \(catalog.archetypes.count) archetypes, \(catalog.attributes.count) attributes, \(catalog.rules.count) rules, \(catalog.muscleGroups.count) muscle groups")
            
            // Debug: Print first few archetypes
            for (index, archetype) in catalog.archetypes.prefix(3).enumerated() {
                print("🔍 ExerciseCatalog: Archetype \(index): \(archetype.displayName) (\(archetype.key))")
            }
                    } catch {
                print("❌ ExerciseCatalog: Failed to parse hardcoded JSON: \(error)")
                print("❌ ExerciseCatalog: Error details: \(error.localizedDescription)")
                // Fallback to empty catalog if loading fails
                self.muscleGroups = []
                self.muscleSubgroups = [:]
                self.attributes = []
                self.archetypes = []
                self.rules = []
            }
    }
    
    // MARK: - Public API
    
    /// Search archetypes by query (text, muscle group, or muscle subgroup)
    func searchArchetypes(query: String) -> [Archetype] {
        let searchQuery = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if searchQuery.isEmpty {
            return archetypes
        }
        
        return archetypes.filter { archetype in
            archetype.searchableText.contains(searchQuery) ||
            archetype.primaryMuscle.lowercased().contains(searchQuery) ||
            archetype.secondaryMuscles.contains { $0.lowercased().contains(searchQuery) } ||
            archetype.primarySubgroups.contains { $0.lowercased().contains(searchQuery) } ||
            archetype.secondarySubgroups.contains { $0.lowercased().contains(searchQuery) }
        }
    }
    
    /// Get allowed values for a specific attribute, considering current selections and rules
    func allowedValues(for attributeKey: String, archetype: Archetype?, current: [String: Any]) -> [String] {
        guard let attribute = attributes.first(where: { $0.key == attributeKey }),
              let values = attribute.values else {
            return []
        }
        
        var allowedValues = Set(values)
        
        // Apply global rules
        let globalRules = rules.filter { $0.scope == "global" && $0.target == attributeKey }
        for rule in globalRules {
            if let ifCondition = rule.if, isConditionSatisfied(ifCondition, current: current) {
                if let allowValues = rule.allow?[attributeKey] {
                    allowedValues = allowedValues.intersection(allowValues)
                }
                if let denyValues = rule.deny?[attributeKey] {
                    allowedValues = allowedValues.subtracting(denyValues)
                }
            }
        }
        
        // Apply archetype-specific rules
        if let archetype = archetype {
            let archetypeRules = rules.filter { 
                $0.scope == "archetype" && 
                $0.archetype == archetype.key && 
                $0.target == attributeKey 
            }
            
            for rule in archetypeRules {
                if let ifCondition = rule.if, isConditionSatisfied(ifCondition, current: current) {
                    if let allowValues = rule.allow?[attributeKey] {
                        allowedValues = allowedValues.intersection(allowValues)
                    }
                    if let denyValues = rule.deny?[attributeKey] {
                        allowedValues = allowedValues.subtracting(denyValues)
                    }
                }
            }
        }
        
        return Array(allowedValues).sorted()
    }
    
    /// Check if a combination of archetype and attributes is valid
    func isCombinationValid(archetypeKey: String, attrs: [String: Any]) -> (ok: Bool, reasons: [String]) {
        guard let archetype = archetypes.first(where: { $0.key == archetypeKey }) else {
            return (false, ["Invalid archetype"])
        }
        
        var reasons: [String] = []
        
        // Check if all selected attributes are allowed for this archetype
        for (key, _) in attrs {
            if !archetype.allowedAttributes.contains(key) {
                reasons.append("Attribute '\(key)' is not allowed for \(archetype.displayName)")
            }
        }
        
        // Check required attributes
        let archetypeRules = rules.filter { 
            $0.scope == "archetype" && 
            $0.archetype == archetypeKey && 
            $0.require != nil 
        }
        
        for rule in archetypeRules {
            if let required = rule.require {
                for requiredAttr in required {
                    if attrs[requiredAttr] == nil {
                        reasons.append("Required attribute '\(requiredAttr)' is missing")
                    }
                }
            }
        }
        
        // Check if current combination satisfies all rules
        let applicableRules = rules.filter { rule in
            if rule.scope == "global" {
                return rule.target != nil && attrs[rule.target!] != nil
            } else if rule.scope == "archetype" && rule.archetype == archetypeKey {
                return rule.target != nil && attrs[rule.target!] != nil
            }
            return false
        }
        
        for rule in applicableRules {
            if let ifCondition = rule.if, isConditionSatisfied(ifCondition, current: attrs) {
                if let target = rule.target, let currentValue = attrs[target] {
                    if let allowValues = rule.allow?[target] {
                        if !allowValues.contains(String(describing: currentValue)) {
                            reasons.append("Value '\(currentValue)' for '\(target)' is not allowed")
                        }
                    }
                    if let denyValues = rule.deny?[target] {
                        if denyValues.contains(String(describing: currentValue)) {
                            reasons.append("Value '\(currentValue)' for '\(target)' is denied")
                        }
                    }
                }
            }
        }
        
        return (reasons.isEmpty, reasons)
    }
    
    /// Build a human-readable display name from archetype and attributes
    /// Excludes default values from the name
    func buildDisplayName(archetypeKey: String, attrs: [String: Any]) -> String {
        guard let archetype = archetypes.first(where: { $0.key == archetypeKey }) else {
            return archetypeKey
        }
        
        var nameParts: [String] = []
        
        // Define the order for attributes in the name
        let attributeOrder = [
            "push_up_style", "crunch_style", // Style attributes first
            "equipment", "bench_angle", "grip_type", "grip_width", 
            "stance_width", "foot_position", "bar_position", "hand_position",
            "handle_type", "is_single_arm", "is_single_leg"
        ]
        
        // Process attributes in order, skipping default values
        for attributeKey in attributeOrder {
            if let value = attrs[attributeKey] as? String,
               let attribute = attributes.first(where: { $0.key == attributeKey }) {
                
                // Skip if this is the default value
                if let defaultValue = attribute.default, value == defaultValue {
                    continue
                }
                
                // Special handling for single side attributes
                if attributeKey == "is_single_arm" || attributeKey == "is_single_leg" {
                    nameParts.append("Single Side")
                } else {
                    // Add the value to the name parts
                    let formattedValue = value.replacingOccurrences(of: "_", with: " ").capitalized
                    nameParts.append(formattedValue)
                }
            }
        }
        
        // Add archetype name
        nameParts.append(archetype.displayName)
        
        return nameParts.joined(separator: " ")
    }
    
    // MARK: - Private Helper Methods
    
    private func isConditionSatisfied(_ condition: [String: [String]], current: [String: Any]) -> Bool {
        for (key, allowedValues) in condition {
            guard let currentValue = current[key] else { return false }
            let currentString = String(describing: currentValue)
            if !allowedValues.contains(currentString) {
                return false
            }
        }
        return true
    }
}
