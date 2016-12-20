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
 * Copyright (C) 2012-2016 COMP_hack Team <compomega@tutanota.com>
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
#include "PushIgnore.h"
#include <tinyxml2.h>
#include "PopIgnore.h"

namespace libobjgen
{

class MetaVariable;

class MetaObject
{
public:
    typedef std::list<std::shared_ptr<MetaVariable>> VariableList;
    typedef std::unordered_map<std::string, std::shared_ptr<MetaVariable>>
        VariableMap;

    MetaObject();
    ~MetaObject();

    std::string GetName() const;
    bool SetName(const std::string& name);

    std::string GetBaseObject() const;
    bool SetBaseObject(const std::string& name);

    bool GetPersistent() const;

    std::string GetSourceLocation() const;
    void SetSourceLocation(const std::string& location);

    std::string GetXMLDefinition() const;
    void SetXMLDefinition(const std::string& xmlDefinition);
    void SetXMLDefinition(const tinyxml2::XMLElement& root);

    std::string GetError() const;

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

    bool Load(const tinyxml2::XMLDocument& doc,
        const tinyxml2::XMLElement& root, bool verifyReferences = true);
    bool LoadTypeInformation(const tinyxml2::XMLDocument& doc,
        const tinyxml2::XMLElement& root);
    bool LoadMembers(const tinyxml2::XMLDocument& doc,
        const tinyxml2::XMLElement& root, bool verifyReferences);
    bool Save(tinyxml2::XMLDocument& doc,
        tinyxml2::XMLElement& root) const;

    bool HasCircularReference() const;

    std::set<std::string> GetReferences() const;

    static std::unordered_map<std::string, MetaObject*> GetKnownObjects();

protected:
    static std::shared_ptr<MetaVariable> CreateType(
        const std::string& typeName);

    bool LoadMember(const tinyxml2::XMLDocument& doc, const char *szName,
        const tinyxml2::XMLElement *pMember, bool& result);
    std::shared_ptr<MetaVariable> GetVariable(const tinyxml2::XMLDocument& doc,
        const char *szName, const char *szMemberName,
        const tinyxml2::XMLElement *pMember);

private:
    void GetReferences(std::shared_ptr<MetaVariable>& var,
        std::set<std::string>& references) const;

    bool HasCircularReference(const std::set<std::string>& references) const;

    const tinyxml2::XMLElement *GetChild(const tinyxml2::XMLElement *pMember,
        const std::string name) const;

    bool DefaultsSpecified(const tinyxml2::XMLElement *pMember) const;

    static std::unordered_map<std::string, MetaObject*> sKnownObjects;

    std::string mName;
    std::string mBaseObject;
    bool mPersistent;
    std::string mSourceLocation;
    std::string mXmlDefinition;

    std::string mError;
    bool mReferencesVerified;
    VariableList mVariables;
    VariableMap mVariableMapping;
};

} // namespace libobjgen

#endif // LIBOBJGEN_SRC_METAOBJECT_H
