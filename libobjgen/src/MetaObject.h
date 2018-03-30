/**
 * @file libobjgen/src/MetaObject.h
 * @ingroup libobjgen
 *
 * @author COMP Omega <compomega@tutanota.com>
 *
 * @brief Meta data for an object.
 *
 * This file is part of the COMP_hack Object Generator Library (libobjgen).
 *
 * Copyright (C) 2012-2018 COMP_hack Team <compomega@tutanota.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef LIBOBJGEN_SRC_METAOBJECT_H
#define LIBOBJGEN_SRC_METAOBJECT_H

// Standard C++11 Includes
#include <list>
#include <memory>
#include <set>
#include <string>
#include <unordered_map>

// tinyxml2 Includes
#include <tinyxml2.h>

namespace libobjgen
{

class MetaVariable;

class MetaObject
{
friend class MetaObjectXmlParser;

public:
    typedef std::list<std::shared_ptr<MetaVariable>> VariableList;
    typedef std::unordered_map<std::string, std::shared_ptr<MetaVariable>>
        VariableMap;

    MetaObject();
    ~MetaObject();

    std::string GetName() const;
    bool SetName(const std::string& name);

    std::string GetNamespace() const;
    bool SetNamespace(const std::string& ns);

    std::string GetBaseObject() const;
    bool SetBaseObject(const std::string& name);

    bool IsPersistent() const;
    void SetPersistent(bool persistent);

    bool IsInheritedConstruction() const;
    void SetInheritedConstruction(bool enabled);

    bool IsScriptEnabled() const;
    void SetScriptEnabled(bool scriptEnabled);

    std::string GetSourceLocation() const;
    void SetSourceLocation(const std::string& location);

    bool AddVariable(const std::shared_ptr<MetaVariable>& var);
    bool RemoveVariable(const std::string& name);
    std::shared_ptr<MetaVariable> GetVariable(const std::string& name);

    VariableList::const_iterator VariablesBegin() const;
    VariableList::const_iterator VariablesEnd() const;

    static bool IsValidIdentifier(const std::string& ident);

    bool IsValid() const;

    uint16_t GetDynamicSizeCount() const;

    bool Load(std::istream& stream);
    bool Save(std::ostream& stream) const;
    bool Save(tinyxml2::XMLDocument& doc,
        tinyxml2::XMLElement& root) const;

    std::set<std::string> GetReferencesTypes(
        bool includeNamespace = false) const;
    std::list<std::shared_ptr<MetaVariable>> GetReferences() const;

    void AddInheritedObject(const std::shared_ptr<MetaObject>& obj);
    std::list<std::shared_ptr<MetaObject>> GetInheritedObjects() const;
    void GetAllInheritedObjects(std::list<std::shared_ptr<
        MetaObject>>& objs) const;

private:
    void GetReferences(std::shared_ptr<MetaVariable>& var,
        std::list<std::shared_ptr<MetaVariable>>& references) const;

    std::string mName;
    std::string mNamespace;
    std::string mBaseObject;
    bool mScriptEnabled;
    bool mPersistent;
    bool mInheritedConstruction;
    std::string mSourceLocation;

    VariableList mVariables;
    VariableMap mVariableMapping;

    std::list<std::shared_ptr<MetaObject>> mInheritedObjects;
};

} // namespace libobjgen

#endif // LIBOBJGEN_SRC_METAOBJECT_H
